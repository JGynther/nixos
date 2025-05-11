{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
  fetchFromGitLab,
  ...
}:
let
  tes3cmd = import ./tes3cmd.nix {
    inherit
      stdenv
      lib
      fetchFromGitLab
      pkgs
      ;
  };

  others = import ./others.nix {
    inherit
      lib
      stdenv
      fetchurl
      autoPatchelfHook
      makeWrapper
      pkgs
      ;
  };
in
{
  inherit tes3cmd others;
}
