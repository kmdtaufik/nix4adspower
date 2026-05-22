<div align="center">

# nix4adspower

**A Nix flake providing a secure, containerized FHS environment for AdsPower Global**

[![NixOS](https://img.shields.io/badge/NixOS-5277C3?logo=nixos&logoColor=white)](https://nixos.org/)
[![AdsPower](https://img.shields.io/badge/AdsPower-Anti--Detect-blue)](https://www.adspower.com)

</div>

---

## About AdsPower Global

**AdsPower** is a premier anti-detect browser designed for multi-account management and fingerprint isolation.

Because AdsPower dynamically downloads proprietary, pre-compiled Chromium kernels (like SunBrowser) directly to your home directory, standard Nix packaging methods fail. This flake packages the official upstream `.deb` inside a strict **FHS (Filesystem Hierarchy Standard) environment** (`buildFHSEnv`). This isolates the application and ensures its dynamically downloaded engines have the standard Linux library paths they expect, completely bypassing the need for hacky background patching loops or breaking your system's sandbox.

🚨 **IMPORTANT: Architecture Limitation** 🚨
This package strictly targets `x86_64-linux` as dictated by the upstream proprietary binaries. Do not attempt to evaluate this on Darwin or ARM systems.

---

## Installation

### NixOS Configuration (Flake)

Add the flake to your `flake.nix` inputs. AdsPower is proprietary, so ensure your configuration permits unfree packages.

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix4adspower.url = "github:kmdtaufik/nix4adspower";
  };

  outputs = { nixpkgs, inputs, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.config.allowUnfree = true;

          # Install the AdsPower GUI
          environment.systemPackages = [
            inputs.nix4adspower.packages.x86_64-linux.default
          ];
        })
      ];
    };
  };
}
```

### Home Manager

```nix
{
  inputs = {
    nix4adspower.url = "github:kmdtaufik/nix4adspower";
  };

  outputs = { inputs, ... }: {
    # Ensure allowUnfree is set in your home-manager config
    nixpkgs.config.allowUnfree = true;

    home.packages = [
      inputs.nix4adspower.packages.x86_64-linux.default
    ];
  };
}
```

### Try without installing

You can run the application instantly without modifying your system configuration. Nix will provision the isolated FHS container on the fly:

```bash
nix run github:kmdtaufik/nix4adspower
```
