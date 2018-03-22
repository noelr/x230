{
  packageOverrides = pkgs: with pkgs; {
    myPackages = pkgs.buildEnv {
      name = "my-packages";
      paths = [
        vimHugeX fish tmux git
        cmus
        firefoxWrapper
        signal-desktop
        haskellPackages.hdevtools hlint
      ];
    };
  };
  allowUnfree = true;
}
