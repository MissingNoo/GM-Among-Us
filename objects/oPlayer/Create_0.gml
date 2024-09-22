spd = oLobby.player_speed;
if (!instance_exists(oCamWorld)) {
    instance_create_depth(x, y, depth, oCamWorld);
}
sendtimer = 10;