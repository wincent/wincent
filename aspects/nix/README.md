# Nix package manager

## Examples

```
# Start a shell with the `cowsay` and `lolcat` executables available.
nix-shell -p cowsay lolcat

# Run a command without dropping into a shell.
nix-shell -p cowsay --run "cowsay Nix"

# Run command in a totally reproducible way (pinning exact version; eg. 2.33.1).
# `--pure` cleans the environment and makes _only_ `git` available.
nix-shell -p git --run "git --version" --pure -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz

# Purge downloaded versions cache.
nix-collect-garbage

# Get a shell based on shell.nix declaration file in current directory.
nix-shell
```

## Links

- Official site, [nixos.org](https://nixos.org/).
- Search ([search.nixos.org](https://search.nixos.org/)): eg. for finding `git` is installed with the `git` package, `nvim` is installed with the `neovim` package, and `npm` is installed with the `nodejs` package etc.
- Version information ([status.nixos.org](https://status.nixos.org/): eg. for pinning to specific versions.
- ["Nix (package manager)" on Wikipedia](https://en.wikipedia.org/wiki/Nix_%28package_manager%29).
