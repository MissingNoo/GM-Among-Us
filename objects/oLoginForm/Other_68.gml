var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
	case "UserExist":
		show_message_async("Username already registered!");
		break;
	case "Register":
		sendMessageNew("Login", {username : global.username, password : global.password});
		break;
	case "Login":
		if (r[$ "login"]) {
			oClient.loggedin = true;
			ini_open("settings");
			ini_write_string("Settings", "Username", global.username);
			ini_write_string("Settings", "Password", global.password);
			ini_close();
			instance_create_depth(0, 0, 0, oLobby);
			instance_destroy();
		}
		else {
			oClient.loggedin = false;
			oClient.reason = r[$ "reason"];
			show_message_async(r[$ "reason"]);
		}
		break;
}