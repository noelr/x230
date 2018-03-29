{
  # packageOverrides = pkgs: with pkgs; {
  #   myPackages = pkgs.buildEnv {
  #     name = "my-packages";
  #     paths = [
  #       vimHugeX fish tmux git
  #       cmus
  #       firefoxWrapper
  #       signal-desktop
  #       ghc cabal-install cabal2nix haskellPackages.hdevtools hlint
  #     ];
  #   };
  # };
  allowUnfree = true;
}
