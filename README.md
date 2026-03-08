# Cuda nix flake template
This flake is a template to enable cuda and pytorch with cuda enabled without getting a build that takes a thousand years to finish.
For more information:
- https://github.com/nixos-cuda/infra

## What to do ?
Run :

```shell
$ nix develop
```

if you get:

```shell
warning: ignoring untrusted substituter 'https://nix-community.cachix.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
warning: ignoring untrusted substituter 'https://cache.nixos-cuda.org', you are not a trusted user.
Run `man nix.conf` for more information on the `substituters` configuration option.
```

A quick fix is to just do:

```shell
$ sudo nix develop
```
