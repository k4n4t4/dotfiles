{
  description = "Home";

  inputs = {
    desktop.url = "path:./desktop";
    common.url = "path:./common";
  };

  outputs = inputs: let
    home = builtins.attrNames inputs;
  in builtins.listToAttrs (map (h: {
    name = h;
    value = inputs.${h};
  }) home);
}
