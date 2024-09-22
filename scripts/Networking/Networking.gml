global.__Networking = {};
global.serverip = "127.0.0.1";
global.port = 21320;
#macro MX device_mouse_x_to_gui(0)
#macro MY device_mouse_y_to_gui(0)
#macro left_click device_mouse_check_button_pressed(0, mb_left)
function get_response(async_load) {
	//var type_event = ds_map_find_value(async_load, "type");
	var buffer;
	if (async_load[? "size"] > 0) {
	    _buffer = async_load[? "buffer"];
		buffer_seek(_buffer, buffer_seek_start, 0);
		return json_parse(buffer_read(_buffer, buffer_text));
	}
	return -1;
}

function sendMessageNew(type, data = {}){
	if (oClient.connected != 0) { exit; }
	buffer_seek(oClient.clientBuffer, buffer_seek_start, 0);
	data.username = global.username;
	data.type = type;
	var _json = json_stringify(data);
	//show_debug_message($"Sending data: {json_stringify(data, true)}");
	buffer_write(oClient.clientBuffer, buffer_text, _json);	
	network_send_udp_raw(oClient.client, global.serverip, global.port, oClient.clientBuffer, buffer_tell(oClient.clientBuffer));
}

global.__Networking.basestruct = {
	_x : 0,
	_y : 0,
	text : "",
	func : function(){},
	textscale : 1,
	enabled : true,
	force_sprite : false,
	enterfunc : function(){}
};
function networking_button(data = {
	_x : 0,
	_y : 0,
	text : "",
	func : function(){},
	textscale : 1,
	enabled : true,
	force_sprite : false,
	enterfunc : function(){}
}) {
	var names = struct_get_names(global.__Networking.basestruct);
	for (var i = 0; i < array_length(names); ++i) {
	    if (data[$ names[i]] == undefined) {
		    data[$ names[i]] = global.__Networking.basestruct[$ names[i]];
		}
	}
	alpha = 1;
	var tw = (string_width(data.text) / 3) * data.textscale;
	var sprite_ws = tw / 4;
	var th = string_height(data.text) / 2 * data.textscale;
	var sprite_hs = th / 5;
	var _w = (sprite_get_width(sHudButton) * sprite_ws) / 2;
	var _h = (sprite_get_height(sHudButton) * sprite_hs) / 2;
	var mouse_on = point_in_rectangle(MX, MY, data._x - _w, data._y - _h, data._x + _w, data._y + _h);
	if (mouse_on) { data.enterfunc(); }
	var spr = mouse_on;
	if (data.force_sprite) {
		spr = 1;
	}
	if (!data.enabled) {
		mouse_on = false;
		alpha = 0.5;
	}
	var color = mouse_on or data.force_sprite ? "c_black" : "c_white";
	draw_sprite_ext(sHudButton, spr, data._x, data._y, sprite_ws, sprite_hs, 0, c_white, alpha);
	scribble($"[alpha,{alpha}][fa_center][fa_middle][{color}]{data.text}").scale(data.textscale).draw(data._x, data._y);
	if (data.enabled and mouse_on and device_mouse_check_button_pressed(0, mb_left)) {
		data.func();
	}
}