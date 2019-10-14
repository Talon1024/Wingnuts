# Generic space fighter/bomber class
extends KinematicBody
# WARNING: Do NOT instance Ship.tscn directly. It is meant to be inherited and
# used as a base class for other ships.
#
# Ship subclasses should have the following nodes:
#
# - One or more CollisionShape nodes. Ship is a subclass of KinematicBody, and
#   these "Hitboxes" are required by KinematicBody in order for collision
#   detection to work properly.
#
# - One or more Weapon nodes, as children of the "Guns" node, which will fire
#   when the pilot sets control_data.fire_gun to true
#
# - One or more Weapon nodes, as children of the "Missiles" node, which will
#   fire when the pilot sets control_data.fire_missile to true
#
# - A MeshInstance node named "ShieldVisual", which will flash when the shield
#   takes damage
#
# - For player-flyable ships, two Position3D nodes named "CockpitPosition" and
#   "ChasePosition", which are the positions the cockpit and chase cameras will
#   follow.

class ShieldUnit:
	var sections = []
	func _init(sections_health: Array = []):
		sections = sections_health
		# Ensure I'm doing it right. Section 0 should point forwards
#		print("Section vectors:")
#		for section in range(len(sections)):
#			var vector_rotation = float(section) / len(sections) * PI * 2
#			print(Vector3(0,0,1).rotated(Y_AXIS, vector_rotation))


	# Absorb incoming damage
	# Returns amount of damage to apply to hull
	func absorb(direction: Vector3, damage: int, absorb: bool = true):
		if absorb:
			var damages_per_section = []
			var section_count = len(sections)
			# Determine damage factor for each section
			for section in range(section_count):
				var vector_rotation = float(section) / section_count * PI * 2
				var section_vector = Vector3(0,0,1).rotated(Y_AXIS, vector_rotation)
				var section_damage_factor = -direction.dot(section_vector) + 1
				#print("Section damage factor: ", section_damage_factor)
				damages_per_section.append(section_damage_factor)
			# I used to have a variable named sectionDamageTotal, but it ended
			# up always being the same as the number of shield sections
			var hull_damage = 0
			# Apply the damage
			for section in range(section_count):
				damages_per_section[section] /= section_count
				var damage_left = round(float(damage) * damages_per_section[section])
				sections[section] -= damage_left
				if sections[section] < 0:
					# The hull takes whatever damage the shield section cannot
					hull_damage -= sections[section]  # Negative number
					sections[section] = 0
			return hull_damage
		else:
			return damage

# Resources
onready var shield_visual = $ShieldVisual

# Stats
export var base_health = 100
export var max_speed = 25
export var afterburner_speed = 100
#export var afterburnerAcceleration = 120
#export var acceleration = 30
#export var shieldLevel = 1  # Shield capacitor level
export var pitch_speed = 90  # DPS
export var yaw_speed = 90
export var roll_speed = 90
#export var mass = 100  # Used to determine damage and knockback
onready var health = base_health

# Control
const Pilot = preload("res://scenes/base/Pilot.gd")
var target_velocity: Vector3 = Vector3(0,0,0)
var controller: Pilot = null
var control_data: Dictionary = {
	"yaw": 0.0,
	"pitch": 0.0,
	"roll": 0.0,
	"throttle": 0.0,
	"glide": false,
	"afterburner": false,
	"fire_gun": false,
	"fire_missile": false,
}
var unfire_gun: bool = false
var unfire_missile: bool = false
signal weapon_fired

# Physics
var velocity: Vector3 = Vector3(0,0,0)
var pitch_delta: float = 0 setget _set_pitch_delta
var yaw_delta: float = 0 setget _set_yaw_delta
var roll_delta: float = 0 setget _set_roll_delta
onready var actual_pitch_speed = deg2rad(pitch_speed)
onready var actual_yaw_speed = deg2rad(yaw_speed)
onready var actual_roll_speed = deg2rad(roll_speed)

# Equipment
var shield_unit = ShieldUnit.new([50, 50])
onready var guns = $Guns.get_children()  # Change to GunUnit class
onready var missiles = $Missiles.get_children()  # Change to MissileUnit class
#var active_special = 0  # Special ability, such as cloaking device
var shield_show_time = 0 setget set_shield_time


# Constants
const X_AXIS = Vector3(1,0,0)
const Y_AXIS = Vector3(0,1,0)
const Z_AXIS = Vector3(0,0,1)


func _floorLowValue(value, threshold = .1):
	if abs(value) < threshold:
		return 0
	return value


func set_shield_time(shield_time: float):
	if shield_visual:
		if shield_time > 0:
			shield_visual.visible = true
			var shield_mtl = shield_visual.get_surface_material(0)
			if shield_mtl.has_method("set_shader_param"):
				shield_mtl.set_shader_param("showTime", shield_time)
		else:
			shield_visual.visible = false


# Override these if the ship has thrust pods that rotate when the ship turns
func _set_pitch_delta(pitch_delta: float):
	pass


func _set_yaw_delta(yaw_delta: float):
	pass


func _set_roll_delta(roll_delta: float):
	pass


func _receive_damage(direction: Vector3, position: Vector3, damage: int):
	var damage_to_take = damage
	if shield_unit:
		damage_to_take = shield_unit.absorb(direction, damage)
		if shield_visual:
			$Tween.interpolate_property(self,
					":shield_show_time", 1.0, 0.0, 0.5,
					Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.start()
			var shield_mtl = shield_visual.get_surface_material(0)
			if shield_mtl.has_method("set_shader_param"):
				print("impactDirection: ", direction)
				shield_mtl.set_shader_param("impactDirection", direction)
				shield_mtl.set_shader_param("impactLocation", position)
	health -= damage_to_take


func _process(delta):
	if controller is Pilot:
		control_data = controller.think(delta, control_data)

	pitch_delta = lerp(pitch_delta, actual_pitch_speed * control_data.pitch, .2)
	pitch_delta = _floorLowValue(pitch_delta)
	yaw_delta = lerp(yaw_delta, actual_yaw_speed * control_data.yaw, .2)
	yaw_delta = _floorLowValue(yaw_delta)
	roll_delta = lerp(roll_delta, actual_roll_speed * control_data.roll, .2)
	roll_delta = _floorLowValue(roll_delta)

	if control_data.afterburner:
		target_velocity.z = -afterburner_speed
	else:
		target_velocity.z = -control_data.throttle * max_speed

	if control_data.fire_gun:
		unfire_gun = true
		_handle_firing(guns, "_fire")
	else:
		if unfire_gun:
			_handle_firing(guns, "_unfire")
			unfire_gun = false

	if control_data.fire_missile:
		unfire_missile = true
		_handle_firing(missiles, "_fire")
	else:
		if unfire_missile:
			_handle_firing(missiles, "_unfire")
			unfire_missile = false


# Default weapons firing/"unfiring" logic
func _handle_firing(array, method):
	for gun in array:
			if gun.has_method(method) and gun.call(method):
				emit_signal("weapon_fired",
					self,
					gun.global_transform,
					gun.bullet_scene)


func _physics_process(delta):
	rotate_object_local(X_AXIS, pitch_delta * delta)
	rotate_object_local(Y_AXIS, yaw_delta * delta)
	rotate_object_local(Z_AXIS, roll_delta * delta)

	velocity = velocity.rotated(X_AXIS, -pitch_delta * delta)
	velocity = velocity.rotated(Y_AXIS, -yaw_delta * delta)
	velocity = velocity.rotated(Z_AXIS, -roll_delta * delta)

#	TODO: acceleration
#	var current_acceleration = acceleration
#	if control_data.afterburner:
#		current_acceleration = afterburner_acceleration
	if not control_data.glide:
		velocity = lerp(velocity, target_velocity, .03)
#		velocity = velocity.move_toward(target_velocity, current_acceleration) # Unstable branch feature
	if target_velocity.x == 0:
		velocity.x = _floorLowValue(velocity.x)
	if target_velocity.y == 0:
		velocity.y = _floorLowValue(velocity.y)
	if target_velocity.z == 0:
		velocity.z = _floorLowValue(velocity.z)
	var physvelocity = global_transform.basis.xform(velocity)
	var collision = move_and_collide(physvelocity * delta)
	if collision != null:
		var obj = collision.collider
		if obj.get("shooter") and obj.shooter == self:
			return
		var norm = transform.basis.xform_inv(collision.normal)
		var pos = transform.basis.xform_inv(collision.position)
		# Bounce
		physvelocity = physvelocity.bounce(collision.normal)
		velocity = transform.basis.xform_inv(physvelocity)
		# Do damage
		var damage = 0
		if obj.has_method("get_damage"):
			damage = obj.get_damage()
		_receive_damage(norm, pos, damage)