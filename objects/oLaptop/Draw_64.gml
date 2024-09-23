if (!show) { exit; }
draw_roundrect_color_ext(gw / 2 - rectw, gh / 2 - recth, gw / 2 + rectw, gh / 2 + recth, roundc, roundc, c_white, c_white, false);
draw_roundrect_color_ext(gw / 2 - rect2w, gh / 2 - rect2h + rect2yo, gw / 2 + rect2w, gh / 2 + rect2h + rect2yo, roundc, roundc, c_blue, c_blue, false);
var start_x = gw / 2 - tabsx;
var tabo = 0;
for (var i = 0; i < array_length(tabs); ++i) {
    draw_roundrect_color_ext(start_x - tabsw + tabo, gh / 2 - tabsh - tabsyo, start_x + tabsw + tabo, gh / 2 + tabsh - tabsyo, roundc, roundc, c_purple, c_purple, false);
	if (_NW.left_click and point_in_rectangle(_NW.MX, _NW.MY, start_x - tabsw + tabo, gh / 2 - tabsh - tabsyo, start_x + tabsw + tabo, gh / 2 + tabsh - tabsyo)) {
	    selectedtab = i;
	}
	var color = selectedtab == i ? "c_red" : "c_white";
	scribble($"[{color}][fa_center][fa_middle]{tabs[i]}").draw(start_x + tabo, gh / 2 - tabsyo);
	tabo += tabso;
}