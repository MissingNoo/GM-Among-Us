skip = ["tabs", "options", "show"];
show = false;
tabs = ["Color", "Hat", "Pet", "Skin", "Game"];
options = [
	["Game", "Player Speed: ", "player_speed"],
	["Game", "Kill Cooldown", "kill_cooldown"],
	["Game", "Kill Distance", "kill_distance"],
]

#region Screen Vars
rectw = 1;
recth = 1;
rect2w = 1;
rect2h = 1;
rect2yo = 0;
tabsyo = 0;
tabso = 0;
tabsx = 0;
tabsw = 0;
tabsh = 0;
roundc = 0;
selectedtab = 0;
#endregion



#region Debug
dbg_view("Game Settings", false);
dbg_section("Vars");
var names = struct_get_names(self);
for (var i = 0; i < array_length(names); ++i) {
	if (array_contains(skip, names[i])) { continue; }
	var is = self[$ names[i]];
	if (is_method(is) or is_array(is)) { continue; }
	if (is_string(self[$ names[i]])) {
		dbg_text_input(ref_create(self, names[i]), names[i]);
	}
	if (is_real(self[$ names[i]])) { 
		dbg_slider_int(ref_create(self, names[i]), 1, 500, names[i]);
	}
}
debug_load(self, skip);
#endregion

gw = global.__Networking.gw;
gh = global.__Networking.gh;