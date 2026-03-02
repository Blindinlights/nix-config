{
  description = "My NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    browser-previews.url = "github:nix-community/browser-previews";
    browser-previews.inputs.nixpkgs.follows = "nixpkgs";
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      spicetify-nix,
      ...
    }@inputs:
    let
      vars = import ./hosts/nixos/vars.nix;
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = vars.system;
          specialArgs = { inherit inputs vars; };
          modules = [
            ./hosts/nixos/configuration.nix
          ];
        };
      };
      homeConfigurations = {
        "${vars.user.name}" = home-manager.lib.homeManagerConfiguration {
          pkgs = self.nixosConfigurations.nixos.pkgs;
          extraSpecialArgs = { inherit inputs vars; };
          modules = [ ./hosts/nixos/home.nix ];
        };
      };
    };
}
