{
  description = "Hosts";

  inputs = {
    wsl.url = "path:./wsl";
    laptop.url = "path:./laptop";
    desktop.url = "path:./desktop";
  };

  outputs = { self, ... }@inputs: let
    hosts = builtins.attrNames inputs;
  in {
    make = config: builtins.listToAttrs (map (h: {
      name = h;
      value = inputs.${h}.make config;
    }) hosts);
  };
}
