{config, pkgs, ...}:
{
  wayland.windowManager.hyprland.enable = true;
  home.packages = with pkgs; [
    hyprland
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xwayland
    wofi
    swaybg
    waybar
    mako
    kitty
    waylock
    pulseaudio
    networkmanagerapplet
    pasystray
    pavucontrol
    xfce.thunar
    grim
    slurp
    networkmanager
  ];

  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT_CTRL";
    exec-once = [
      "waybar & hyprpaper & nm-applet, & pasystray & swaybg -i ~/Pictures/maxresdefault.jpg"
    ];

    input = {
      kb_layout = "us";
      kb_options = "ctrl:nocaps";
      accel_profile = "flat";
    };

    general = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      layout = "dwindle";

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      resize_on_border = true;
    };

    decoration = {
      # See https://wiki.hyprland.org/Configuring/Variables/ for more

      rounding = 10;
      
      blur = {
        enabled = false;
        size = 3;
        passes = 1;
      };

      drop_shadow = "yes";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

    bind =
      [
        "$mod, F, exec, librewolf"
        ", Print, exec, grimblast copy area"
        "$mod, Q, exec, kitty"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, E, exec, thunar"
        "$mod, V, togglefloating"
        "$mod, R, exec, wofi --show drun"
        "$mod, N, fullscreen"

        "$mod, LEFT, movefocus, l"
        "$mod, RIGHT, movefocus, r"
        "$mod, UP, movefocus, u"
        "$mod, DOWN, movefocus, d"
        
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
          10)
      );
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.canta-theme;
      #name = "Flat-Remix-GTK-Grey-Darkest";
      name = "Canta-gtk-theme";
    };

    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };


}
