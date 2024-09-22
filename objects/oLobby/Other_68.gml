var r = get_response(async_load);
if (r == -1) { exit; }
switch (r[$ "type"]) {
    case "JoinLobby":
		fsm.change("OnLobby");
		break;
	case "ListLobbies":
		rooms = json_parse(r[$ "lobbies"]);
		break;
	case "UpdatePlayers":
		players = json_parse(r[$ "players"]);
		break;
	case "LeaveLobby":
		fsm.change("Rooms");
		break;
	case "IsHost":
		ishost = r[$ "isHost"];
		break;
	case "StartGame":
		fsm.change("OnStage");
		break;
}
