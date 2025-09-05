# Cuda nix flake template
This flake is a template to enable cuda and pytorch with cuda enabled without getting a build that takes a thousand years to finish. This is simply done by using cachix : https://nixos.wiki/wiki/CUDA.

** NOTE ** : torch-bin, torchvision-bin and torchaudio-bin have cuda enabled by default ! DO NOT USE cudaSupport = true or torchWithCuda.

## What to do ?
Run :
```
$ sudo nix develop --accept-flake-config
```
to download everything from the cachix cache (sudo is to trust the client specified "trusted-public-keys" in the flake).

To reduce future build times when calling nix develop after nix-collect-garbage, you can also put all the outputs of the devshell in your cachix cache:
```
$ nix develop .#default --profile ./dev-profile --accept-flake-config
$ cachix push mycache dev-profile # push to your cachix cache
```
Don't forget to add:
```
  nixConfig = {
    extra-substituters = [
      "https://mycache.cachix.org"
    ];
    extra-trusted-public-keys = [
        "mycache.cachix.org-1:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" # get this from your cachix cache page
    ];
  };
```
Next time you run `sudo nix develop` or `nix develop`, it will download from your cachix cache instead of the public one.
