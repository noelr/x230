
Add nixos-unstable channel (without sudo!)

```bash
nix-channel --add https://nixos.org/channels/nixos-unstable unstable
```

Install hdevtools
```bash
nix-env -f "<nixpkgs>" -iA haskellPackages.hdevtools
```
