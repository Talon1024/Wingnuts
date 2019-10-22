extends Control

onready var Player = get_parent().find_node("Player")

func _ready():
	$RadarContainer/Viewport.canvas_transform = Transform2D(
		Vector2.RIGHT, Vector2.DOWN, Vector2(64, 64))

func _process(delta):
	var set_speed = 0
	if Player.control_data.afterburner:
		set_speed = Player.afterburner_speed
	else:
		set_speed = Player.control_data.throttle * Player.max_speed

	$SetContainer/SetDisplay.text = "SET: %.4f" % set_speed
	$KpsContainer/KpsDisplay.text = "KPS: %.4f" % Player.velocity.length()

	if Player.control_data.glide:
		$SetContainer/SetDisplay.text += "G"
		$KpsContainer/KpsDisplay.text += "G"