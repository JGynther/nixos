{
  appimageTools,
  fetchurl,
  makeDesktopItem,
}: let
  pname = "awakened-poe-trade";
  version = "3.27.101";

  src = fetchurl {
    url = "https://github.com/SnosMe/awakened-poe-trade/releases/download/v${version}/Awakened-PoE-Trade-${version}.AppImage";
    hash = "sha256-aQaTuFdtavhCRqbm3StxpNeEndS7l91d4SWA61p5rrg=";
  };

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "Awakened PoE Trade";
    categories = [
      "Game"
      "Utility"
    ];
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cp ${desktopItem}/share/applications/* $out/share/applications
    '';
  }
# {}
# sha256:ca2b30edb73f75f83172ac5ba8a5493a2e9a1bb1e9beb143213841683d240299

