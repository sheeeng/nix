# https://github.com/tommy-donavon/nixos-dots/blob/d824d5ec55109f65f0bc5e042198cafde0fbedc8/modules/home/programs/terminal/editors/helix/nix.nix

{ ... }:
{
  programs.helix.languages = {
    language-server = {
      yaml-language-server = {
        config.yaml = {
          completion = true;
          validation = true;
          hover = true;
          # schemaStore.enable = true;
        };
        config.yaml.schemas = {
          # ansible tasks
          "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/tasks" = "tasks/*.{yml,yaml}";
          # ansible playbooks
          "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook" = "*ansible*/*.{yml,yaml}";
          # kustomization
          "http://json.schemastore.org/kustomization" = "kustomization.{yml,yaml}";
          # helm chart
          "http://json.schemastore.org/chart" = "Chart.{yml,yaml}";
          # helmfile
          "http://json.schemastore.org/helmfile.json" = "helmfile.{yml,yaml}";
          # gitlab-ci
          "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json" = "*gitlab-ci*.{yml,yaml}";
          # argo workflows
          "https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json" = "*flow*.{yml,yaml}";
          # taskfile
          "http://json.schemastore.org/taskfile.json" = "Taskfile*.{yml,yaml}";
          # kubernetes
          # "https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.30.0/all.json" = "/*.yaml";
          # github workflow
          "http://json.schemastore.org/github-workflow" = ".github/workflows/*";
          # github actions
          "http://json.schemastore.org/github-action" = ".github/action.{yml,yaml}";
          # flux kustomization
          "https://raw.githubusercontent.com/fluxcd-community/flux2-schemas/main/kustomization-kustomize-v1.json" = "ks.{yml,yaml}";
          # flux helmrelease
          "https://kubernetes-schemas.pages.dev/helm.toolkit.fluxcd.io/helmrelease_v2beta2.json" = "helmrelease.{yml,yaml}";
          # externalsecrets
          "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json" = "external*secret.{yml,yaml}";
        };
      };
    }; # https://github.com/brenix/nix-config/blob/85dd440897b731a338b7a85a0bd038b83091682e/modules/home/programs/terminal/editors/helix/languages.nix#L15-L52
  };
}
