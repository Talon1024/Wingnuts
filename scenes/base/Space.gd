extends Spatial

const Ship = preload("res://scenes/base/Ship.gd")
const SpaceEnvironment = preload("res://scenes/base/SpaceEnvironment.gd")
const PlayerPilot = preload("res://scenes/pilots/PlayerPilot.gd")

onready var cockpitCamera: Camera = $Player/Camera
onready var chaseCamera: InterpolatedCamera = $ChaseCamera


func _setup_env():
	# Setup environment according to user's settings
	var environment: Environment = $SpaceEnvironment.environment
	environment.tonemap_mode = Settings.tonemap
	environment.ssao_enabled = Settings.ssao


func _setup_camera(cam: Camera, target: Node = null):
	if cam.has_method("set_target"):
		# It's an InterpolatedCamera
		cam.set_target(target)
		cam.enabled = true
	cam.transform = target.transform
	cam.keep_aspect = Camera.KEEP_WIDTH
	cam.far = 1000
	cam.fov = Settings.fov


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Set up chase camera
	_setup_camera(chaseCamera, $Player/ChasePosition)
	# Set up cockpit camera and use it as the default
	_setup_camera(cockpitCamera, $Player/CockpitPosition)
	cockpitCamera.make_current()
	PlayerInfo.ship = $Player
	PlayerInfo.ship.visible = false
	PlayerInfo.ship.add_child(PlayerPilot.new())
	PlayerInfo.emit_signal("added_to_ship", PlayerInfo.ship)
	OS.window_size = Settings.resolution
	_setup_env()
	for child in get_children():
		if child is Light:
			child.shadow_enabled = Settings.shadows


func _process(delta):
	if Input.is_action_just_pressed("camera_chase"):
		chaseCamera.make_current()
		PlayerInfo.ship.visible = true
	elif Input.is_action_just_pressed("camera_front"):
		cockpitCamera.make_current()
		PlayerInfo.ship.visible = false


func _on_Player_weapon_fired(shooter: Ship, transform: Transform, weapon_scene: PackedScene):
	var bullet = weapon_scene.instance()
	bullet.add_collision_exception_with(shooter)
	bullet.global_transform = transform
	var speed = bullet.speed
	if bullet.add_speed:
		speed += shooter.velocity.length()
	bullet.velocity = transform.basis.xform(Vector3.FORWARD * speed)
	self.add_child(bullet)
