{ lib, ... }:
let
palette = (lib.importJSON ../static/palette.json).macchiato.colors;
in{
console = {
	font = "Lat2-Terminus16";
	keyMap = "us";
	colors = map (which_color: (lib.substring 1 6 palette.${which_color}.hex)) [
      "base"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext1"

      "surface2"
      "red"
      "green"
      "yellow"
      "blue"
      "pink"
      "teal"
      "subtext0"
    ];

};

}
