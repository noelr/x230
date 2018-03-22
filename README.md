
Add nixos-unstable channel (without sudo)

```bash
nix-channel --add https://nixos.org/channels/nixos-unstable nixpkgs
nix-env -iA nixpkgs.myPackages
```
