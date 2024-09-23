sendtimer = clamp(sendtimer - 1, 0, 20);
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
		sendtimer = 20;
	    sendMessageNew("MovePlayer", {x, y});
	}
}
else {
	sprite_index = sIdle;
}
if (!place_meeting(x + hspd, y, oCollision)) {
    x += hspd;
}
else {
	if (!place_meeting(x + sign(hspd), y, oCollision)) {
	    x += sign(hspd);
	}
}
if (!place_meeting(x, y + vspd, oCollision)) {
    y += vspd;
}
else {
	if (!place_meeting(x, y+ sign(vspd), oCollision)) {
	    y += sign(vspd);
	}
}