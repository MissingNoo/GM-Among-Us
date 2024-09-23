skip = ["skip"];
#region Functions
function textbox(data = {
	x: 0,
	y: 0,
	text: "",
	variable: "",
	instance: noone,
	width : 100,
	color : c_white,
	func : function() {}
}) {
	if (_NW.left_click and point_in_rectangle(_NW.MX, _NW.MY, data.x - (data.width / 2), data.y - 8, data.x + (data.width / 2), data.y + 8)) {
	    data.func();
	}
	draw_rectangle_color(data.x - (data.width / 2), data.y - 8, data.x + (data.width / 2), data.y + 8, data.color, data.color, data.color, data.color, true);
	var value = variable_instance_get(data.instance, data.variable);
	scribble($"[fa_center][fa_middle]{value != "" ? value : data.text}").draw(data.x, data.y);
}
#endregion
gw = global.__Networking.gw;
gh = global.__Networking.gh;
selected = 0;
#region Vars
username = "";
password = "";
form_scale_x = 1;
form_scale_y = 1;
add_offset = 10;
title_scale = 1;
title_offset = 1;
text_scale = 1;
button_offset = 1;
button_yoffset = 1;
#endregion
#region Debug
dbg_view("LoginForm", false);
dbg_section("Vars");
dbg_button("Save", function() { debug_save(); });
dbg_same_line();
dbg_button("Load", function() { debug_load(); });
var names = struct_get_names(self);
for (var i = 0; i < array_length(names); ++i) {
	if (array_get_index(skip, names[i]) != -1) { continue; }
	if (is_method(self[$ names[i]])) { continue; }
	if (is_string(self[$ names[i]])) {
		dbg_text_input(ref_create(self, names[i]), names[i]);
	}
	if (is_real(self[$ names[i]])) { 
		dbg_slider_int(ref_create(self, names[i]), 1, 100, names[i]);
	}
}
debug_load(self, skip);
keyboard_string = username;
if (global.username != "" and global.password != "") {
	//sendMessageNew("Login", {username : global.username, password : global.password});
}
#endregion