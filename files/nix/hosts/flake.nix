{
  description = "Hosts";

  inputs = {
    wsl.url = "path:./wsl";
    laptop.url = "path:./laptop";
    desktop.url = "path:./desktop";
  };

  outputs = inputs: let
    hosts = builtins.attrNames inputs;
  in builtins.listToAttrs (map (h: {
    name = h;
    value = inputs.${h};
  }) hosts);
}
