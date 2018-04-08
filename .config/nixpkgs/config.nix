{
  packageOverrides = pkgs: with pkgs; {
    myHaskell = pkgs.buildEnv {
      name = "my-haskell";
      paths = [
         ghc cabal-install cabal2nix hlint haskellPackages.hdevtools
      ];
    };
    myPhoenix = pkgs.buildEnv {
      name = "my-phoenix";
      paths = [
         elixir nodejs postgresql
      ];
    };
    myRails = pkgs.buildEnv {
      name = "my-rails";
      paths = [
         ruby_2_4 bundix nodejs postgresql
      ];
    };
  };
  allowUnfree = true;
}
