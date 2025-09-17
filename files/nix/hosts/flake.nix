{
  description = "Hosts";

  inputs = {
    wsl.url = "path:./wsl";
    laptop.url = "path:./laptop";
    desktop.url = "path:./desktop";
  };

  outputs = { self, ... }@inputs: {
    make = config: {
      wsl = inputs.wsl.make config;
      laptop = inputs.laptop.make config;
      desktop = inputs.desktop.make config;
    };
  };
}
