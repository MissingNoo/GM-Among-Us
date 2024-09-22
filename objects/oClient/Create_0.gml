var fnts = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 :][\",}{";
global.font = font_add_sprite_ext(sFont, fnts, true, 1);
scribble_font_bake_outline_4dir("sFont", "sOFont", c_black, true);
scribble_font_set_default("sFont");
scribble_font_scale("sFont", 0.25);
scribble_font_force_bilinear_filtering("sFont", true);
scribble_font_force_bilinear_filtering("sOFont", false);
global.__Networking.gw = display_get_gui_width();
global.__Networking.gh = display_get_gui_height();
gw = global.__Networking.gw;
gh = global.__Networking.gh;
if (instance_number(oClient) > 1) { instance_destroy(); }
showinfo = false;
infoOffset = [1000, 1000];
loggedin = false;
reason = "";

ini_open("settings");
global.username = ini_read_string("Settings", "Username", "");
global.password = ini_read_string("Settings", "Password", "");
ini_close();

client = network_create_socket(network_socket_tcp);
clientBuffer = buffer_create(4098, buffer_fixed, 1);
keepalive = time_source_create(time_source_game, 5, time_source_units_seconds,function(){ 
				//sendMessage(0, {command : Network.KeepAlive, roomname : global.roomname})
			});
var _timestate = time_source_get_state(keepalive);
if(_timestate == time_source_state_initial or _timestate == time_source_state_stopped){
	time_source_start(keepalive);
}

connected = -1;
try {
	connected = network_connect_raw(client, global.serverip, global.port);
	if (connected >= 0) {
		reason = "Connection Sucessful";
	}
	else {
		reason = "Server Unreachable";
	}
}
catch (error) {
	reason = "Network Error";
}