{
  description = "Configuration";

  inputs = {
    hosts.url = "path:./hosts";
    home.url = "path:./home";
  };

  outputs = { hosts, home, ... }: {
    nixosConfigurations = hosts;
    homeConfigurations = home;
  };
}
