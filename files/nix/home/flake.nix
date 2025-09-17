{
  description = "Home";

  inputs = {
    common.url = "path:./common";
    desktop.url = "path:./desktop";
  };

  outputs = { self, ... }@inputs: let
    home = builtins.attrNames inputs;
  in {
    make = config: builtins.listToAttrs (map (h: {
      name = h;
      value = inputs.${h}.make config;
    }) home);
  };
}
