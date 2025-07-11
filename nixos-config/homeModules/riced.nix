{ config, pkgs, lib, inputs, ... }:

{
  home.username = "rsanchez";
  home.homeDirectory = "/home/rsanchez";
  home.stateVersion = "24.05";

  # Import catppuccin
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  # Enable catppuccin theming
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
    
    # Enable for specific programs
    kitty.enable = true;
    starship.enable = true;
    hyprland.enable = true;
    waybar.enable = true;
    mako.enable = true;
  };

  # Terminal emulator
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 11;
      background_opacity = "0.8";
      window_padding_width = 15;
      
      # Catppuccin Mocha colors
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      
      # Black
      color0 = "#45475A";
      color8 = "#585B70";
      
      # Red
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      
      # Green
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      
      # Yellow
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      
      # Blue
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      
      # Magenta
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      
      # Cyan
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      
      # White
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
  };

  # Shell prompt
  programs.starship = {
    enable = true;
  };

  # Shell
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    
    # Add npm global bin to PATH
    initExtra = ''
      export PATH="$HOME/.npm-global/bin:$PATH"
      
      # Run neofetch on terminal start
      if [[ $- == *i* ]]; then
        neofetch
      fi
    '';
  };

  # Editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Hyprland configuration
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      
      monitor = ",preferred,auto,1";
      
      exec-once = [
        "swww init"
        "waybar"
        "mako"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
      ];

      general = {
        gaps_in = 8;
        gaps_out = 15;
        border_size = 3;
        "col.active_border" = "$mauve $pink 45deg";
        "col.inactive_border" = "$surface0";
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      bind = [
        # Programs
        "$mod, RETURN, exec, kitty"
        "$mod, SPACE, exec, wofi --show drun"
        "$mod, E, exec, thunar"
        "$mod, B, exec, firefox"
        "$mod, N, exec, nm-connection-editor"  # Network settings
        
        # Window management
        "$mod, Q, killactive"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        
        # Focus
        "$mod, H, movefocus, l"
        "$mod, L, movefocus, r"
        "$mod, K, movefocus, u"
        "$mod, J, movefocus, d"
        
        # Move windows
        "$mod SHIFT, H, movewindow, l"
        "$mod SHIFT, L, movewindow, r"
        "$mod SHIFT, K, movewindow, u"
        "$mod SHIFT, J, movewindow, d"
        
        # Workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        
        # Move to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        
        # Screenshot
        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
        "$mod, Print, exec, grim - | wl-copy"  # Full screen to clipboard
        "$mod SHIFT, Print, exec, grim -g \"$(slurp)\" ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png"  # Save to file
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # Waybar
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        spacing = 0;
        margin-top = 5;
        margin-left = 10;
        margin-right = 10;
        
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = ["clock"];
        modules-right = ["network" "cpu" "memory" "pulseaudio" "battery" "tray"];
        
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
          on-click = "activate";
        };
        
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
        };
        
        clock = {
          format = " {:%H:%M}";
          format-alt = " {:%A, %B %d, %Y}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        
        cpu = {
          interval = 2;
          format = " {usage}%";
          tooltip = true;
        };
        
        memory = {
          interval = 2;
          format = " {}%";
          tooltip-format = "Memory: {used:0.1f}G/{total:0.1f}G";
        };
        
        network = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " Connected";
          format-disconnected = "⚠ Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
        };
        
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = ["" "" "" "" ""];
        };
        
        tray = {
          spacing = 10;
        };
      };
    };
    
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }
      
      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
        border-radius: 10px;
      }
      
      #waybar.empty {
        background: transparent;
      }
      
      /* Workspaces */
      #workspaces {
        margin: 0 5px;
      }
      
      #workspaces button {
        padding: 0 5px;
        color: #cdd6f4;
        background: transparent;
        border-radius: 5px;
        margin: 0 2px;
      }
      
      #workspaces button.active {
        background: #cba6f7;
        color: #1e1e2e;
      }
      
      #workspaces button:hover {
        background: rgba(203, 166, 247, 0.2);
      }
      
      /* Modules */
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 0 3px;
        background: rgba(49, 50, 68, 0.6);
        border-radius: 5px;
      }
      
      #window {
        margin: 0 10px;
        color: #a6adc8;
      }
      
      /* Colors for specific modules */
      #battery.charging {
        color: #a6e3a1;
      }
      
      #battery.critical:not(.charging) {
        background-color: #f38ba8;
        color: #1e1e2e;
        animation: blink 0.5s linear infinite alternate;
      }
      
      #network.disconnected {
        background-color: #f38ba8;
        color: #1e1e2e;
      }
      
      #pulseaudio.muted {
        background-color: #a6adc8;
        color: #1e1e2e;
      }
      
      @keyframes blink {
        to {
          background-color: #eba0ac;
        }
      }
    '';
  };

  # Notification daemon
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-size = 2;
      border-radius = 10;
      padding = "10";
      width = 300;
    };
  };

  # Wofi
  programs.wofi = {
    enable = true;
    settings = {
      width = 600;
      height = 400;
      location = "center";
      show = "drun";
      prompt = "Search...";
      filter_rate = 100;
      allow_images = true;
      image_size = 40;
      gtk_dark = true;
      insensitive = true;
    };
    
    style = ''
      window {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-radius: 10px;
      }
      
      #input {
        margin: 5px;
        border: none;
        color: #cdd6f4;
        background-color: #313244;
        border-radius: 5px;
      }
      
      #inner-box {
        margin: 5px;
        border: none;
        background-color: transparent;
      }
      
      #entry:selected {
        background-color: #cba6f7;
        color: #1e1e2e;
        border-radius: 5px;
      }
    '';
  };

  # Additional packages
  home.packages = with pkgs; [
    # File manager
    xfce.thunar
    
    # System utilities
    brightnessctl
    playerctl
    pamixer
    
    # Development
    ripgrep
    fd
    bat
    eza
    zoxide
    fzf
    nodejs_22
    claude-code  # Our custom Claude package!
    
    # Rice utilities
    neofetch
    htop
    btop
    
    # Wallpapers
    swww
    
    # Screenshots
    grim
    slurp
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Key detection
    wev  # Wayland event viewer
  ];

  # Set wallpaper
  home.file.".config/hypr/wallpaper.sh" = {
    text = ''
      #!/usr/bin/env bash
      swww img ~/Pictures/wallpaper.jpg --transition-type fade --transition-duration 2
    '';
    executable = true;
  };
  
  # Neofetch configuration
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        info title
        info underline

        info "OS" distro
        info "Host" model
        info "Kernel" kernel
        info "Uptime" uptime
        info "Packages" packages
        info "Shell" shell
        info "Resolution" resolution
        info "DE" de
        info "WM" wm
        info "Terminal" term
        info "CPU" cpu
        info "GPU" gpu
        info "Memory" memory
        
        info cols
    }

    # Shorten the output
    kernel_shorthand="on"
    distro_shorthand="off"
    os_arch="on"
    uptime_shorthand="on"
    memory_percent="off"
    package_managers="on"
    shell_path="off"
    shell_version="on"
    cpu_brand="on"
    cpu_speed="on"
    gpu_brand="on"
    gpu_type="all"
    
    # Text Colors
    colors=(distro)
    
    # Text Options
    bold="on"
    underline_enabled="on"
    underline_char="-"
    
    # Backend Settings
    image_backend="ascii"
    ascii_distro="nixos"
    ascii_colors=(distro)
    ascii_bold="on"
    
    # Image Options
    image_size="auto"
    gap=3
  '';
}
