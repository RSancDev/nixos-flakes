{ config, pkgs, lib, ... }:

{
  # Boot configuration
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
  };

  # Networking
  networking.hostName = "rice-machine";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "America/Los_Angeles"; # Change to your timezone
  i18n.defaultLocale = "en_US.UTF-8";

  # User configuration
  users.users.rsanchez = {
    isNormalUser = true;
    description = "Rudy Sanchez";
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.05";
}
