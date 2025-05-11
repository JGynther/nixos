{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
}:
let
  version = "0.1";

  sources = {
    configurator = fetchurl {
      url = "https://gitlab.com/modding-openmw/momw-configurator/-/package_files/179588151/download";
      sha512 = "d6de654b658a5aeee8a20dfd01ee03cc65af5c76d36bf988eaa7f091fa128d1a9239ed8e5d1d3953abd5b91f03f1c5b8673cc232571ac28520c31bd03202f472";
      name = "configurator.zip";
    };

    delta = fetchurl {
      url = "https://gitlab.com/bmwinger/delta-plugin/-/releases/0.22.3/downloads/delta-plugin-0.22.3-linux-amd64.zip";
      sha512 = "37a0a3ce8ea6e96690ca2450bace3c7ed23589828b5127256d69fa923013498d3533b77bf04afc819f81f8c080a73f327d34dbdd030ca2d2903e7d57fedc9148";
      name = "delta-plugin.zip";
    };

    lightfixes = fetchurl {
      url = "https://github.com/magicaldave/S3LightFixes/releases/download/v0.3.3/ubuntu-latest.zip";
      sha512 = "5f062b02476f07a1baa2669832eaa2f9ce96e3d231871383be0732e076ea846dfc5df95d7a09e18c4ae9859b8d1d67df9c4fb7c54b797f3174d6970809f07b3c";
      name = "s3lightfixes.zip";
    };

    vfstool = fetchurl {
      url = "https://github.com/magicaldave/vfstool/releases/download/v0.1.6/ubuntu-latest.zip";
      sha512 = "8d8be9171e243fa065b7f9b14d2a6d4ff370bff3a5caa7b42f3e52bcc2065338ad47a65899b47f6b37737ee9a66c0967f4cdb0abd73289c19503a572264a28ff";
      name = "vfstool.zip";
    };

    groundcoverify = fetchurl {
      url = "https://gitlab.com/api/v4/projects/modding-openmw%2Fgroundcoverify/jobs/artifacts/exeify/raw/dist/groundcoverify-linux.tar.gz?job=linux";
      sha512 = "ccc4987c7ac82aebb2bbb87ba24b7dd1a3d2a6825dd4a2a0fc7e57046e52d9307fa2da2e4640402db5da7464ae86dea1853cec0eda3f54b88a4c608257bcacd4";
      name = "groundcoverify.tar.gz";
    };

    validator = fetchurl {
      url = "https://gitlab.com/modding-openmw/openmw-validator/-/package_files/159324029/download";
      sha512 = "14251cf16d557ef9c33d7df22de19e48ae9dca8a6e4bd0979f9be49ab3853766c01ad69287280004e12de00a0b89978fca76b913113f6f8cc4ca10bf77683fb8";
      name = "validator.zip";
    };
  };
in
stdenv.mkDerivation {
  pname = "momw-tools-other";
  inherit version;

  srcs = [
    sources.configurator
    sources.delta
    sources.lightfixes
    sources.vfstool
    sources.groundcoverify
    sources.validator
  ];

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    pkgs.unzip
  ];

  buildInputs = with pkgs; [
    zlib
    stdenv.cc.cc.lib
  ];

  unpackPhase = ''
    unzip -o ${sources.configurator}
    unzip -o ${sources.delta}
    unzip -o ${sources.lightfixes}
    unzip -o ${sources.vfstool}
    tar xf ${sources.groundcoverify}
    unzip -o ${sources.validator}
  '';

  installPhase = ''
    mkdir -p $out/bin

    install -m755 momw-configurator/momw-configurator-linux-amd64 $out/bin/momw-configurator-linux-amd64
    install -m755 delta_plugin $out/bin/delta_plugin
    install -m755 s3lightfixes $out/bin/s3lightfixes
    install -m755 vfstool $out/bin/vfstool
    install -m755 groundcoverify $out/bin/groundcoverify
    install -m755 openmw-validator/openmw-validator-linux-amd64 $out/bin/openmw-validator-linux-amd64
  '';

  meta = with lib; {
    description = "Tools for modding Morrowind with OpenMW";
    homepage = "https://modding-openmw.com/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
