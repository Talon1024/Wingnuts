extends Camera3D


@onready var radius = translation.length()
var phi = 0
var theta = PI / 2


func _process(delta):
	if current:
		if Input.is_action_pressed("turn_left"):
			phi += 1 * delta
		elif Input.is_action_pressed("turn_right"):
			phi -= 1 * delta
		if Input.is_action_pressed("pitch_up"):
			theta += 1 * delta
		elif Input.is_action_pressed("pitch_down"):
			theta -= 1 * delta

		# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Coordinate_system_conversions
		translation.x = radius * sin(theta) * cos(phi)
		translation.z = radius * sin(theta) * sin(phi)
		translation.y = radius * cos(theta)
		look_at(get_parent().translation, get_parent().transform.basis.y)
