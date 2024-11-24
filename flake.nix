{
  description = "Nix Derivation for Wallpaper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
    forEachSystem = nixpkgs.lib.genAttrs systems;
    pkgs = forEachSystem (system: import nixpkgs {inherit system;});
  in {
    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forEachSystem (system: {
      default = pkgs.${system}.stdenv.mkDerivation {
        name = "wallpapers";
        src = ./.;
        installPhase = ''
          randomwallpaper=$(find . -name "*.png" -type f | shuf -n 1)
          mkdir -p $out
          cp "$randomwallpaper" $out/random.png
        '';
      };
    });
  };
}
