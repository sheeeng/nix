import { tool } from "@opencode/tool-utils";
import { spawnSync } from "child_process";

export default tool({
  name: "bash",
  description: "Execute bash commands in a sandboxed environment using srt.",
  parameters: {
    command: {
      type: "string",
      description: "The bash command to execute",
    },
  },
  execute: async ({ command }: { command: string }) => {
    const result = spawnSync("srt", ["bash", "-c", command], {
      encoding: "utf8",
      maxBuffer: 10 * 1024 * 1024, // 10MB
    });

    if (result.error) {
      throw new Error(`Failed to execute command: ${result.error.message}`);
    }

    return {
      stdout: result.stdout,
      stderr: result.stderr,
      exitCode: result.status,
    };
  },
});
