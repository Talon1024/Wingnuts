extends Node3D

const Ship = preload("res://scenes/base/Ship.gd")
const PlayerPilot = preload("res://scenes/pilots/PlayerPilot.gd")


@onready var cockpitCamera: Camera3D = $Player/Camera
@onready var chaseCamera: Camera3D = $ChaseCamera
@onready var outsideCamera: Camera3D = $Player/OutsideCamera


func _setup_env():
	pass


func _setup_camera(cam: Camera3D, target: Node = null):
	if target:
		cam.transform = target.transform
		if cam.has_method("set_target"):
			# It's an InterpolatedCamera
			cam.set_target(target)
			cam.enabled = true
	cam.keep_aspect = Camera3D.KEEP_WIDTH
	cam.far = 1000
	cam.fov = Settings.fov


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Set up chase camera
	_setup_camera(chaseCamera, $Player/ChasePosition)
	# Set up cockpit camera and use it as the default
	_setup_camera(cockpitCamera, $Player/CockpitPosition)
	_setup_camera(outsideCamera, null)
	cockpitCamera.make_current()
	PlayerInfo.ship = $Player
	PlayerInfo.ship.visible = false
	PlayerInfo.ship.add_child(PlayerPilot.new())
	PlayerInfo.emit_signal("added", PlayerInfo.ship)
	DisplayServer.window_set_size(Settings.resolution)
	_setup_env()
	for child in get_children():
		if child is Light3D:
			child.shadow_enabled = Settings.shadows


func _process(delta):
	if Input.is_action_just_pressed("camera_chase"):
		chaseCamera.make_current()
		PlayerInfo.ship.visible = true
	elif (Input.is_action_just_pressed("camera_front") or 
			Input.is_action_just_pressed("camera_left") or
			Input.is_action_just_pressed("camera_right") or
			Input.is_action_just_pressed("camera_back")):
		cockpitCamera.make_current()
		PlayerInfo.ship.visible = false
	elif Input.is_action_just_pressed("camera_outside"):
		outsideCamera.make_current()
		PlayerInfo.ship.visible = true


func _on_weapon_fired(shooter: Ship, transform: Transform, weapon_scene: PackedScene):
	var bullet = weapon_scene.instance()
	bullet.add_collision_exception_with(shooter)
	bullet.global_transform = transform
	var speed = bullet.speed
	if bullet.add_speed:
		speed += shooter.velocity.length()
	bullet.velocity = transform.basis.xform(Vector3.FORWARD * speed)
	self.add_child(bullet)
