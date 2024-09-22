sendtimer = clamp(sendtimer - 1, 0, 10);
spd = oLobby.player_speed;
var leftright = -input_check("left") + input_check("right");
var updown = -input_check("up") + input_check("down");
var hspd = leftright * spd;
var vspd = updown * spd;
if (hspd < 0) {
    image_xscale = -0.3;
}
else if (hspd > 0) {
    image_xscale = 0.3;
}
if (leftright != 0 or updown != 0) {
    sprite_index = sWalk;
	if (sendtimer == 0) {
	    sendMessageNew("MovePlayer", {x, y});
	}
}
else {
	sprite_index = sIdle;
}
move_and_collide(hspd, vspd, oCollision);