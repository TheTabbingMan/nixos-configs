{...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        # Fixes black screen with pgu acceleration on xwayland-satellite niri
        package = pkgs.cudaSupported.steam.override {
          extraArgs = "-system-composer";
        };
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
        protontricks.enable = true;
      };
      gamescope.enable = true;
      gamemode.enable = true;
    };
    environment.systemPackages = with pkgs; [gamescope-wsi];

    services.sunshine = {
      enable = true;
      package = pkgs.cudaSupported.sunshine;
      autoStart = true;
      capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
      openFirewall = true;
    };
  };
  flake.homeModules.gaming = {pkgs, ...}: {
    home.packages = with pkgs; [
      osu-lazer-bin
      protontricks
      (heroic.override {
        extraPkgs = pkgs':
          with pkgs'; [
            gamescope
            gamemode
            mangohud
          ];
      })
      cartridges
      ryubing
      eden
      prismlauncher
      protonplus
      scopebuddy
      lsfg-vk
      lsfg-vk-ui
      mangohud
    ];
    services.flatpak.packages = [
      rec {
        appId = "org.flybywiresim.installer";
        sha256 = "sha256-S68PYfVv5UqXf4yhwnHRth8MNMj43tQu9+6TitlMoac=";
        bundle = "${pkgs.fetchurl {
          url = "https://github.com/flybywiresim/installer/releases/download/v3.7.0/FlyByWire-Installer-3.7.0-x86_64.flatpak";
          inherit sha256;
        }}";
      }
      "xyz.rust4diva.Rust4Diva"
      "com.usebottles.bottles"
      "org.freedesktop.Platform.VulkanLayer.MangoHud//25.08"
      "org.freedesktop.Platform.VulkanLayer.lsfgvk//24.08"
      "org.freedesktop.Platform.VulkanLayer.lsfgvk//25.08"
      "net.retrodeck.retrodeck"
    ];
  };
}
