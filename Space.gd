extends Spatial

const PlayerPilot = preload("res://PlayerPilot.gd")

onready var player = $Player
onready var cockpitCamera: Camera = $Player/Camera
onready var chaseCamera: InterpolatedCamera = $ChaseCamera
onready var chaseView = false

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

func _process(delta):
	if Input.is_action_just_pressed("camera_chase"):
		chaseCamera.make_current()
		player.visible = true
	elif Input.is_action_just_pressed("camera_front"):
		cockpitCamera.make_current()
		player.visible = false

func _on_Player_weapon_fired(shooter: KinematicBody, transform: Transform, weapon_scene: PackedScene):
	print("bullet global transform: ", transform)
	var bullet = weapon_scene.instance()
	bullet.shooter = shooter
	bullet.global_transform = transform
	bullet.velocity = transform.basis.xform(Vector3.BACK * bullet.speed)
	add_child(bullet)
