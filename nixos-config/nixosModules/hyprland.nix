{ config, pkgs, lib, ... }:

{
  # Display manager
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Shell
  programs.zsh.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
  ];

  # Essential packages for Hyprland
  environment.systemPackages = with pkgs; [
    #OG Setup
    git
    curl
    wget
    vim
    kitty
    wofi
    waybar
    swww
    mako
    grim
    slurp
    wl-clipboard
    polkit_gnome

    #Web Browsers
    librewolf
  ];

  # Enable polkit
  security.polkit.enable = true;

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
}
