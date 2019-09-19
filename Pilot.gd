extends Object

enum ShipControl {
	PITCH,
	YAW,
	ROLL,
	THROTTLE,
	GLIDE,
}

func think(delta, controls: Array):
	return controls