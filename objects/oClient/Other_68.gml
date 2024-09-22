var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
    case "MovePlayer":
		var name = r[$ "username"];
		var xz = r[$ "x"];
		var yz = r[$ "y"];
		with (oSlave) {
		    if (username == name) {
			    xx = xz;
			    yy = yz;
			}
		}
		//if (!instance_exists(oSlave)) { break; }
		//oSlave.xx = r[$ "x"];
		//oSlave.yy = r[$ "y"];
		//if (oSlave.character == 0) {
		//	oSlave.character = r[$ "character"];
		//	oSlave.spd = global.characters[oSlave.character][? "speed"];
		//	oSlave.sprite = global.characters[oSlave.character][? "sprite"];
		//	oSlave.runsprite = global.characters[oSlave.character][? "runningsprite"];
		//}
		break;
}