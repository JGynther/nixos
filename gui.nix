{pkgs, ...}: {
  # Niri
  programs.niri.enable = true;
  services.greetd = {
    enable = true;
    settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Setup nvidia drivers
  hardware.graphics.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  # Enable audio via PipeWire
  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
}
