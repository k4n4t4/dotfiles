{
  description = "Configuration";

  inputs = {
    hosts.url = "path:./hosts";
    home.url = "path:./home";
  };

  outputs = { self, ... }@inputs: let
    config = {
      version = "24.11";
      username = "kanata";
    };
  in {
    nixosConfigurations = inputs.hosts.make config;
    homeConfigurations = inputs.home.make config;
  };
}
