# Cuda nix flake template
This flake is a template to enable cuda and pytorch with cuda enabled without getting a build that takes a thousand years to finish. This is simply done by using cachix : https://nixos.wiki/wiki/CUDA.
NOTE : torch-bin, torchvision-bin and torchaudio-bin have cuda enabled by default ! DO NOT USE cudaSupport = true or torchWithCuda.

## What to do ?
Run :
```
$ nix develop --accept-flake-config
```
