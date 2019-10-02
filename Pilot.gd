extends Object

enum ShipControl {
	PITCH,
	YAW,
	ROLL,
	THROTTLE,
	GLIDE,
	AFTERBURNER,
	FIRE_GUN,
	FIRE_MISSILE,
}

func think(delta, controls: Array):
	return controls