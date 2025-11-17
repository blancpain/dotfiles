# Networking configuration for NixOS
# This provides a minimal, working network setup that should work for most systems

{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Set your hostname here
  networking.hostName = lib.mkDefault "nixos";

  # NetworkManager is the easiest and most reliable option for most users
  # It handles WiFi, Ethernet, VPN, etc. with a simple interface
  networking.networkmanager.enable = true;

  # Fallback to DHCP for all interfaces
  networking.useDHCP = lib.mkDefault true;

  # Enable firewall by default for security
  networking.firewall = {
    enable = true;
    # Allow common development ports (uncomment as needed)
    # allowedTCPPorts = [ 22 80 443 3000 8080 ];
    # allowedUDPPorts = [ ];
  };

  # Enable mDNS for .local domain resolution (useful for local network discovery)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      workstation = true;
    };
  };

  # Enable SSH server (disabled by default for security)
  # Uncomment to enable remote access
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #   };
  # };
}
