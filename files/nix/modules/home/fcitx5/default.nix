{ inputs, pkgs, lib, config, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  home = {
    sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
    file = {
      ".config/fcitx5/profile" = {
        text = ''
          [Groups/0]
          Name=Default
          Default Layout=us
          DefaultIM=mozc

          [Groups/0/Items/0]
          Name=mozc
          Layout=

          [GroupOrder]
          0=Default
        '';
        force = true;
      };
      ".config/fcitx5/conf/mozc.conf" = {
        text = ''
          InitialMode=Direct
          InputState="Follow Global Configuration"
          Vertical=True
          ExpandMode="On Focus"
          PreeditCursorPositionAtBeginning=False
          ExpandKey=
        '';
        force = true;
      };
      ".config/fcitx5/conf/classicui.conf" = {
        text = ''
          Vertical Candidate List=False
          WheelForPaging=True
          Font="Sans 10"
          MenuFont="Sans 10"
          TrayFont="Sans Bold 10"
          TrayOutlineColor=#000000
          TrayTextColor=#ffffff
          PreferTextIcon=False
          ShowLayoutNameInIcon=True
          UseInputMethodLanguageToDisplayText=True
          Theme=default-dark
          DarkTheme=default-dark
          UseDarkTheme=False
          UseAccentColor=True
          PerScreenDPI=False
          ForceWaylandDPI=0
          EnableFractionalScale=True
        '';
        force = true;
      };
    };
  };
}
