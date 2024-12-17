{
  description = "Nixos config flake with Proxmox support";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";  # Add Proxmox-NixOS input
  };

  outputs = { self, nixpkgs, proxmox-nixos, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        proxmox-nixos.nixosModules.proxmox-ve  # Add Proxmox VE module
        ({ pkgs, lib, ... }: {
          services.proxmox-ve = {
            enable = true;
            ipAddress = "10.0.0.52";  # Set your desired Proxmox IP address
          };

          nixpkgs.overlays = [
            proxmox-nixos.overlays.x86_64-linux  # Apply the Proxmox overlay
          ];

          # You can add other configuration settings as needed here
        })
      ];
    };
  };
}

