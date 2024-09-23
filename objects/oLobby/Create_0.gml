if (instance_number(oLobby) > 1) { instance_destroy(); }
#region Player Menu
show_players = false;
plist_position = 0;
show_button_y = 0;
#endregion
#region GameVars
player_speed = 3;
dbg_view("Lobby", false);
dbg_section("Vars");
dbg_button("Save", function() { debug_save(); });
dbg_same_line();
dbg_button("Load", function() { debug_load(); });
var names = struct_get_names(self);
for (var i = 0; i < array_length(names); ++i) {
	//if (array_get_index(skip, names[i]) != -1) { continue; }
	if (is_method(self[$ names[i]])) { continue; }
	if (is_string(self[$ names[i]])) {
		dbg_text_input(ref_create(self, names[i]), names[i]);
	}
	if (is_real(self[$ names[i]])) { 
		dbg_slider_int(ref_create(self, names[i]), 1, 100, names[i]);
	}
}
#endregion
#region Functions
function lobby_button(){}

#endregion
#region Basic variables
gw = global.__Networking.gw;
gh = global.__Networking.gh;
lobbyname = "";
rooms = [];
selectedroom = -1;
ishost = 0;
players = ["", ""];
wl = [-750, -750, -751];
chattext = "";
chatmessages = [];
#endregion
fsm = new SnowState("Rooms");
fsm.add("Rooms", {
	enter : function() {
		sendMessageNew("ListLobbies");
		selectedroom = 0;
		reloadcooldown = 60 * 5;
	},
	step : function() {
		reloadcooldown = clamp(reloadcooldown - 1, 0, infinity);
		selectedroom = clamp(selectedroom - input_check_pressed("up") + input_check_pressed("down"), 0, array_length(rooms) - 1);
		if (array_length(rooms) == 0) {
		    selectedroom = -1;
		}
	},
	draw : function() {
		networking_button({
			_x : 120,
			_y :40,
			text: "Create",
			func: function(){
				if (oLobby.fsm.get_current_state() != "CreateLobby") {
					oLobby.fsm.change("CreateLobby");
				}
			}
		});
		networking_button({
			_x : 320,
			_y : 40,
			text : "Join",
			func: function(){
				if (oLobby.selectedroom != -1 and oLobby.fsm.get_current_state() != "JoiningLobby") {
					oLobby.fsm.change("JoiningLobby");
				}
			}
		});
		networking_button({
			_x : 520,
			_y : 40,
			text : "Reload",
			func: function(){
				if (oLobby.reloadcooldown == 0) {
					oLobby.reloadcooldown = 60 * 5;
					sendMessageNew("ListLobbies");
				}
			}
		});
		var offset = 0;
		for (var i = 0; i < array_length(rooms); i++) {
			var color = selectedroom == i ? "c_yellow" : "c_white";
			rooms[1] = rooms[0];
			draw_sprite_ext(sNetworkingHud, 0, gw/2, 110 + offset, 30, 1.25, 0, c_white, 1);
			scribble($"[{color}][fa_middle][fa_left]{rooms[i].name}").scale(3).draw(gw/2 - 700, 110 + offset);
			scribble($"[fa_middle][fa_right][{rooms[i].protected ? sprite_get_name(sLockLobby) : sprite_get_name(sNBlank)}] [{color}]{rooms[i].totalplayers}/2").scale(3).draw(gw/2 + 700, 110 + offset);
			offset += 65;
		}
	}
});

fsm.add_child("Rooms", "CreateLobby", {
	enter : function() {
		wl = [-750, 0, -751];
		lobbyname = "";
		lobbypass = "";
		keyboard_string = "";
		editing = 0;
	},
	step : function() {
		if (input_check_pressed("pause")) {
			wl[1] = wl[2];
		}
		
		if (wl[0] == wl[2]) {
			fsm.change("Rooms");
		}
		if(string_length(keyboard_string) > 10) {
			keyboard_string = string_copy(keyboard_string, 1, 10);
		}
		switch (editing) {
			case 0:
				lobbyname = keyboard_string;
				break;
			case 1:
				lobbypass = keyboard_string;
				break;
		}
		
	},
	draw : function() {
		fsm.inherit();
		var _x = gw/2;
		var _y = gh/2 + wl[0];
		var _w = (sprite_get_width(sNetworkingHud) * 7) / 2;
		var _rw = _w - 50;
		var _rh = 20;
		draw_sprite_ext(sNetworkingHud, 0, _x, _y, 7, 8, 0, c_white, 1);

		_y -= 145;
		scribble("[fa_top][fa_center]Create").scale(3).draw(_x, _y);

		_y += 65;
		scribble("[fa_center][fa_middle]Name").scale(2.5).draw(_x, _y);
		_y += 40;
		var color = editing == 0 ? c_purple : c_white;
		draw_roundrect_color_ext(_x - _rw, _y - _rh, _x + _rw, _y + _rh, 5, 5, color, color, true);
		scribble($"[fa_center][fa_middle]{lobbyname}").scale(2.5).draw(_x, _y);
		if(point_in_rectangle(_NW.MX, _NW.MY, _x - _rw, _y - _rh, _x + _rw, _y + _rh) and device_mouse_check_button_pressed(0, mb_left)) {
			editing = 0;
			keyboard_string = lobbyname;
		}

		_y += 50;
		scribble("[fa_center][fa_middle]Password").scale(2.5).draw(_x, _y);
		_y += 40;
		color = editing == 1 ? c_purple : c_white;
		draw_roundrect_color_ext(_x - _rw, _y - _rh, _x + _rw, _y + _rh, 5, 5, color, color, true);
		scribble($"[fa_center][fa_middle]{lobbypass}").scale(2.5).draw(_x, _y);
		if(point_in_rectangle(_NW.MX, _NW.MY, _x - _rw, _y - _rh, _x + _rw, _y + _rh) and device_mouse_check_button_pressed(0, mb_left)) {
			editing = 1;
			keyboard_string = lobbypass;
		}

		_y += 60;
		networking_button({
			_x : _x + 63,
			_y : _y,
			text: "Create",
			func: function(){
				sendMessageNew("CreateLobby", {name : oLobby.lobbyname, password : oLobby.lobbypass});
			}
		});
		networking_button({
			_x : _x - 63,
			_y: _y,
			text: "Cancel",
			func: function(){
				wl[1] = wl[2];
			}
		});
	}
});

fsm.add_child("Rooms", "JoiningLobby", {
	enter : function() {
		wl = [-750, 0, -751];
		/// @instancevar {Any} rooms
		/// @instancevar {Any} selectedroom
		lobbyname = rooms[selectedroom].name;
		lobbypass = "";
		keyboard_string = "";
		editing = 1;
		if (!rooms[selectedroom].protected) {
			sendMessageNew("JoinLobby", {name : lobbyname, password : lobbypass});
		}
	},
	step : function() {
		if (input_check_pressed("pause")) {
			wl[1] = wl[2];
		}
		wl[0] = lerp(wl[0], wl[1], 0.25);
		if (wl[0] == wl[2]) {
			/// @instancevar {Any} fsm
			fsm.change("Rooms");
		}
		if(string_length(keyboard_string) > 10) {
			keyboard_string = string_copy(keyboard_string, 1, 10);
		}
		switch (editing) {
			case 0:
				lobbyname = keyboard_string;
				break;
			case 1:
				lobbypass = keyboard_string;
				break;
		}
		
	},
	draw : function() {
		fsm.inherit();
		var _x = gw/2;
		var _y = gh/2 + wl[0];
		var _w = (sprite_get_width(sNetworkingHud) * 7) / 2;
		var _rw = _w - 50;
		var _rh = 20;
		draw_sprite_ext(sNetworkingHud, 0, _x, _y, 7, 5.50, 0, c_white, 1);
		
		_y -= 100;
		scribble("[fa_top][fa_center]Create").scale(3).draw(_x, _y);

		_y += 65;
		scribble("[fa_center][fa_middle]Password").scale(2.5).draw(_x, _y);
		_y += 40;
		color = editing == 1 ? c_purple : c_white;
		draw_roundrect_color_ext(_x - _rw, _y - _rh, _x + _rw, _y + _rh, 5, 5, color, color, true);
		scribble($"[fa_center][fa_middle]{lobbypass}").scale(2.5).draw(_x, _y);
		if(point_in_rectangle(_NW.MX, _NW.MY, _x - _rw, _y - _rh, _x + _rw, _y + _rh) and device_mouse_check_button_pressed(0, mb_left)) {
			editing = 1;
			keyboard_string = lobbypass;
		}

		_y += 60;
		networking_button({
			_x : _x + 63,
			_y : _y,
			text : "Join",
			func : function(){
				sendMessageNew("JoinLobby", {name : lobbyname, password : lobbypass});
			}
		});
		networking_button({
			_x : _x - 63,
			_y : _y,
			text : "Cancel",
			func : function(){
				oLobby.wl[1] = oLobby.wl[2];
			}
		});
	}
});

fsm.add("OnLobby", {
	enter : function() {
		sendMessageNew("UpdatePlayers", {});
	},
	step : function() {
	},
	draw : function() {
		networking_button({
			_x : gw - 120,
			_y : 40,
			text: "Leave",
			func: function(){
				sendMessageNew("LeaveLobby");
				room_goto(rLobby);
			}
		});
		networking_button({
			_x : gw - 120,
			_y : 95, 
			text : "Start Game",
			func : function(){
				sendMessageNew("StartGame");
			},
			enabled : oLobby.ishost
		});
	}
});

fsm.add("OnStage",{
	enter : function() {
	},
	step : function() {
	},
	draw : function() {
	}
});