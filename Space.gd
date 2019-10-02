extends Spatial

const PlayerPilot = preload("res://PlayerPilot.gd")

onready var player = $Player
onready var cockpitCamera: Camera = $Player/Camera
onready var chaseCamera: InterpolatedCamera = $ChaseCamera
onready var chaseView = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player.controller = PlayerPilot.new()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Set up chase camera
	chaseCamera.set_target($Player/ChasePosition)
	chaseCamera.transform = $Player/ChasePosition.transform
	chaseCamera.enabled = true
	chaseCamera.far = 1000
	# Set up cockpit camera and use it as the default
	cockpitCamera.transform = $Player/CockpitPosition.transform
	cockpitCamera.make_current()
	cockpitCamera.far = 1000
	player.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Put skybox at camera position
#	var sbTransform = camera.get_global_transform()
#	$Skybox.transform.origin = sbTransform.origin

	if Input.is_action_just_pressed("toggle_chase"):
		toggle_chasecam()

func toggle_chasecam():
	if chaseView:
		cockpitCamera.make_current()
	else:
		chaseCamera.make_current()

	chaseView = not chaseView
	player.visible = not player.visible