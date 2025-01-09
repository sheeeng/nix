# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/kubernetes/default.nix

{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    fluxcd
    # helm
    # helmfile
    k9s
    kind
    krew
    kube-capacity
    kubectl
    kubectl-explore
    kubectl-gadget
    kubectl-images
    kubectl-klock
    kubectl-ktop
    kubectl-neat
    kubectl-node-shell
    kubectl-tree
    kubectl-validate
    kubectl-view-allocations
    kubectl-view-secret
    kubectx
    kubelogin
    kubernetes-helm
    kustomize
    stern
    vals
  ];

  home.shellAliases = rec {
    # helm = lib.getExe pkgs.helm;
    # h = helm;
    # kube = lib.getExe pkgs.kubectl;
    # k = kube;
    # k9 = lib.getExe pkgs.k9s;
  };

  home.sessionVariables = {
    # KUBE_EDITOR = "nvim"; # # TODO: Conflicting error. Use `lib.mkForce value` or `lib.mkDefault value` to change the priority on any of these definitions.
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.krew/bin" ];
}
