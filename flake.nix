{
  description = "Nixos config flake with Proxmox support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };

  outputs = { self, nixpkgs, proxmox-nixos, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        proxmox-nixos.nixosModules.proxmox-ve
        ({ pkgs, lib, ... }: {

          # spiceproxy seems to want this directory even though it is empty
          #   maybe there is a better way to fix it but this works.
          systemd.tmpfiles.rules = [
            "d /usr/share/fonts 0755 root root -"
            "d /usr/share/fonts/truetype 0755 root root -"
            "d /usr/share/fonts/truetype/glyphicons 0755 root root -"
          ];

          services.proxmox-ve = {
            enable = true;
            ipAddress = "10.0.0.65";  #same as vmbr0
          };
          systemd.services.spiceproxy = {
            description = "PVE SPICE Proxy Server";
            wantedBy = [ "multi-user.target" ];
            after = [ "pveproxy.service" ];
            wants = [ "pveproxy.service" ];
            serviceConfig = {
              ExecStartPre = [
                "${pkgs.coreutils}/bin/touch /var/lock/spiceproxy.lck"
                "${pkgs.coreutils}/bin/chown www-data:www-data /var/lock/spiceproxy.lck"
              ];
              ExecStart = "${pkgs.proxmox-ve}/bin/spiceproxy start";
              ExecStop = [
                "${pkgs.coreutils}/bin/rm -f /var/lock/spiceproxy.lck"
                "${pkgs.proxmox-ve}/bin/spiceproxy stop"
              ];
              ExecReload = "${pkgs.proxmox-ve}/bin/spiceproxy restart";
              PIDFile = "/run/pveproxy/spiceproxy.pid"; # the code puts it here, not in /run/spiceproxy/
              Type = "forking";
              Restart = "on-failure";
            };
          };
          nixpkgs.overlays = [
            proxmox-nixos.overlays.x86_64-linux
          ];
        })
      ];
    };
  };
}
