# TODO: https://github.com/uesyn/dotfiles/blob/a28964187ab74b880f2e8ae561359451e9a05e29/home-manager/kubernetes/default.nix

{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    fluxcd
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
  ];

  home.sessionVariables = {
    KUBE_EDITOR = "nvim";
  };

  home.sessionPath = [ "${config.home.homeDirectory}/.krew/bin" ];
}
