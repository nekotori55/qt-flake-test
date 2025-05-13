{
  description = "A Nix-flake-based C/C++ development environment";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixpkgs-qt-511 = {
         url = "github:NixOS/nixpkgs/893c51bda8b7502b43842f137258d0128097d7ea";
         flake = false; };
  inputs.nixpkgs-gcc = { url = "github:nixos/nixpkgs/e83687fe8ef183aa9afc46bbbcce797d6232ccc2";
  flake = false; };

  outputs = inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import inputs.nixpkgs { inherit system; };
        qt-pkgs = import inputs.nixpkgs-qt-511 { inherit system; };
        nixpkgs-gcc = import inputs.nixpkgs-gcc { inherit system; };
      });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs, qt-pkgs, nixpkgs-gcc }: {
        default = pkgs.mkShell.override
          {
            # Override stdenv in order to change compiler:
             stdenv = nixpkgs-gcc.gcc5Stdenv;
          }
          {
            packages = with pkgs; [
               qt-pkgs.qt5.full
               pkgs.qtcreator
            ];
          };
      });
    };
}

https://lazamar.co.uk/nix-versions/?package=gcc-wrapper&version=5.3.0&fullName=gcc-wrapper-5.3.0&keyName=gcc5&revision=e83687fe8ef183aa9afc46bbbcce797d6232ccc2&channel=nixpkgs-unstable#instructions
