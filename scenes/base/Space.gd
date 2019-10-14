extends Spatial

const PlayerPilot = preload("res://scenes/base/PlayerPilot.gd")
const Ship = preload("res://scenes/base/Ship.gd")

onready var player = $Player
onready var cockpitCamera: Camera = $Player/Camera
onready var chaseCamera: InterpolatedCamera = $ChaseCamera


func _setup_env():
	# Setup environment according to user's settings
	var environment = $SpaceEnvironment


func _setup_camera(cam: Camera, target: Node = null):
	if cam.has_method("set_target"):
		# It's an InterpolatedCamera
		cam.set_target(target)
		cam.enabled = true
	cam.transform = target.transform
	cam.keep_aspect = Camera.KEEP_WIDTH
	cam.far = 1000
	cam.fov = 100  # Get from settings


func _ready():
	player.controller = PlayerPilot.new()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Set up chase camera
	_setup_camera(chaseCamera, $Player/ChasePosition)
	# Set up cockpit camera and use it as the default
	_setup_camera(cockpitCamera, $Player/CockpitPosition)
	cockpitCamera.make_current()
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
	var speed = bullet.speed
	if bullet.add_speed:
		speed += shooter.velocity.length()
	bullet.velocity = transform.basis.xform(Vector3.FORWARD * speed)
	print("bullet speed: ", bullet.velocity.length())
	self.add_child(bullet)