if (speed != 0) {
    sprite_index = sWalk;
}
else {
	sprite_index = sIdle;
}
if (xx - x > 5 or yy - y > 5 or xx - x < -5 or yy - y < -5) {
	move_towards_point(xx, yy, oLobby.player_speed);
}
else {
	speed = 0;
}
if (xx > x) {
    image_xscale = 0.3;
}
else if (xx < x) {
    image_xscale = -0.3;
}