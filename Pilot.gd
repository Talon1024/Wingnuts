extends Object

enum ShipControl {
	PITCH,
	YAW,
	ROLL,
	THROTTLE,
	GLIDE,
	AFTERBURNER,
}

func think(delta, controls: Array):
	return controls