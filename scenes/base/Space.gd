extends Spatial

const PlayerPilot = preload("res://scenes/base/PlayerPilot.gd")
const Ship = preload("res://scenes/base/Ship.gd")

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

func _on_Player_weapon_fired(shooter: Ship, transform: Transform, weapon_scene: PackedScene):
	var bullet = weapon_scene.instance()
	bullet.add_collision_exception_with(shooter)
	bullet.global_transform = transform
	var speed = bullet.speed + shooter.velocity.length()
	bullet.velocity = transform.basis.xform(Vector3.FORWARD * speed)
	add_child(bullet)
