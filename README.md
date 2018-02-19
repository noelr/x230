nix-env -i geht ohne sudo nicht:

Sicherstellen, dass .nix-profile im home stimmt:

```bash
.nix-profile -> /nix/var/nix/profiles/per-user/noel/profile/
```

Wenn

```bash
pkg-config --libs --cflags openssl
```

keinen output liefert dann

```bash
nix-shell -p openssl zlib pkgconfig
```
