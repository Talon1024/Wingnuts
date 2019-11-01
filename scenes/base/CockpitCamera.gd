extends Camera

func _ready():
	var tween = Tween.new()
	tween.name = "Tween"
	add_child(tween)

func _process(delta):
	if Input.is_action_just_pressed("camera_front"):
		tween_to_rotation(0)
	elif Input.is_action_just_pressed("camera_left"):
		tween_to_rotation(PI / 2) # 90
	elif Input.is_action_just_pressed("camera_right"):
		tween_to_rotation(-PI / 2)
	elif Input.is_action_just_pressed("camera_back"):
		tween_to_rotation(PI)

func tween_to_rotation(radians: float):
	$Tween.interpolate_property(
		self, ":rotation:y", rotation.y, radians, .25,
		Tween.TRANS_QUAD, Tween.EASE_OUT, 0)
	$Tween.start()