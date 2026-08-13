import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const argumentsList = process.argv.slice(2);
const printJson = argumentsList.includes("--json");
const query = argumentsList.filter((argument) => argument !== "--json").join(" ").trim();

if (!query) {
  console.error('Usage: node scripts/find-effect.mjs "<query>" [--json]');
  process.exit(1);
}

const catalogUrl = new URL("../assets/catalog.json", import.meta.url);
const catalog = JSON.parse(readFileSync(fileURLToPath(catalogUrl), "utf8"));
const terms = query.toLowerCase().split(/\s+/).filter(Boolean);

const results = catalog.effects
  .map((effect) => {
    const name = effect.name.toLowerCase();
    const description = effect.description?.toLowerCase() ?? "";
    const prompt = effect.prompt?.toLowerCase() ?? "";
    const parameter = effect.parameter?.toLowerCase() ?? "";
    const score = terms.reduce(
      (total, term) =>
        total +
        (name.includes(term) ? 8 : 0) +
        (description.includes(term) ? 4 : 0) +
        (parameter.includes(term) ? 2 : 0) +
        (prompt.includes(term) ? 1 : 0),
      0,
    );
    return { effect, score };
  })
  .filter(({ score }) => score > 0)
  .sort((left, right) => right.score - left.score || left.effect.name.localeCompare(right.effect.name))
  .slice(0, 10);

if (printJson) {
  console.log(JSON.stringify(results, null, 2));
} else {
  console.log(
    results
      .map(
        ({ effect, score }) =>
          `${score}\t${effect.name}\t${effect.parameter ?? "unspecified"}\t${effect.description}`,
      )
      .join("\n"),
  );
}
