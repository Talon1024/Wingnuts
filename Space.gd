extends Spatial

const PlayerPilot = preload("res://PlayerPilot.gd")

onready var player = $Player
onready var camera = $Player/Camera

# Called when the node enters the scene tree for the first time.
func _ready():
	player.controller = PlayerPilot.new()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Put skybox at camera position
	var sbTransform = camera.get_global_transform()
	$Skybox.transform.origin = sbTransform.origin

	if Input.is_action_just_pressed("toggle_chase"):
		toggle_chasecam()

func toggle_chasecam():
	var chaseCamPos = camera.translation
	camera.translation = $Player/Cockpit.translation
	$Player/Cockpit.translation = chaseCamPos
	$Player/MeshInstance.visible = not $Player/MeshInstance.visible