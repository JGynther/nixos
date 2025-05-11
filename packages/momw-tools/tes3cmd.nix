{
  stdenv,
  lib,
  fetchFromGitLab,
  pkgs,
}:
stdenv.mkDerivation {
  pname = "tes3cmd";
  version = "0.40-momw";

  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "tes3cmd";
    rev = "91f7e332a04750c88a32bc95833aa5016666a63b";
    hash = "sha256-0UTd3yGmkUUvsZBqz+pzYuG5EdG10fJmdKn2Pqzi3cA=";
  };

  buildInputs = with pkgs; [
    perlPackages.perl
    libxcrypt-legacy
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -m755 tes3cmd $out/bin/tes3cmd
  '';

  meta = with lib; {
    description = "Command line tool for examining and modifying plugins for the Elder Scrolls game Morrowind by Bethesda Softworks";
    mainProgram = "tes3cmd";
    homepage = "https://modding-openmw.com/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
