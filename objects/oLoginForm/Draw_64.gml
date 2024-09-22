networking_button({
	_x : 10,
	_y : 60,
	text: "Login1",
	func: function(){
		global.username = "Air";
		global.password = "123";
		sendMessageNew("Login", {username : global.username, password : global.password});
	}
});
networking_button({
	_x : 10,
	_y : 90,
	text: "Login2",
	func: function(){
		global.username = "A";
		global.password = "123";
		sendMessageNew("Login", {username : global.username, password : global.password});
	}
});

draw_sprite_ext(sNetworkingHud, 0, gw / 2, gh / 2, form_scale_x, form_scale_y, 0, c_white, 1);
var title_start_offset = (sprite_get_height(sNetworkingHud) * form_scale_y) / 2;
var _x = gw / 2;
var _y = gh / 2 + title_offset - title_start_offset;
scribble("[fa_center][fa_top]Login").scale(title_scale).draw(_x, _y);
_y += add_offset;
textbox({
	x: _x,
	y: _y,
	text: "Username",
	variable: "username",
	instance: oLoginForm,
	width : 100,
	color : oLoginForm.selected == 0 ? c_yellow : c_white,
	func : function() { 
		keyboard_string = oLoginForm.username;
		oLoginForm.selected = 0;
	}
});

_y += add_offset;
textbox({
	x: _x,
	y: _y,
	text: "Password",
	variable: "password",
	instance: oLoginForm,
	width : 100,
	color : oLoginForm.selected == 1 ? c_yellow : c_white,
	func : function() {
		keyboard_string = oLoginForm.password;
		oLoginForm.selected = 1;
	}
});

_y += add_offset + button_yoffset;
networking_button({
	_x : _x - button_offset,
	_y,
	text: "Login",
	func: function(){
		global.username = oLoginForm.username;
		global.password = oLoginForm.password;
		sendMessageNew("Login", {username : global.username, password : global.password});
	}
});
networking_button({
	_x : _x + button_offset,
	_y,
	text: "Register",
	func: function(){
		global.username = oLoginForm.username;
		global.password = oLoginForm.password;
		sendMessageNew("Register", {username : global.username, password : global.password});
	}
});