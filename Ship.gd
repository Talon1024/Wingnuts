# Generic space fighter/bomber class
extends KinematicBody

class ShieldUnit:
	var sections = []
	func _init(sectionsHealth: Array = []):
		sections = sectionsHealth
		# Ensure I'm doing it right. Section 0 should point forwards
#		print("Section vectors:")
#		for section in range(len(sections)):
#			var vectorRotation = float(section) / len(sections) * PI * 2
#			print(Vector3(0,0,1).rotated(Y_AXIS, vectorRotation))


	# Absorb incoming damage
	# Returns amount of damage to apply to hull
	func absorb(direction: Vector3, damage: int, absorb: bool = true):
		if absorb:
			var damagesPerSection = []
			var sectionCount = len(sections)
			# Determine damage factor for each section
			for section in range(sectionCount):
				var vectorRotation = float(section) / sectionCount * PI * 2
				var sectionVector = Vector3(0,0,1).rotated(Y_AXIS, vectorRotation)
				var sectionDamageFactor = -direction.dot(sectionVector) + 1
				#print("Section damage factor: ", sectionDamageFactor)
				damagesPerSection.append(sectionDamageFactor)
			# I used to have a variable named sectionDamageTotal, but it ended
			# up always being the same as the number of shield sections
			var hullDamage = 0
			# Apply the damage
			for sectionIndex in range(sectionCount):
				damagesPerSection[sectionIndex] /= sectionCount
				var damageLeft = round(float(damage) * damagesPerSection[sectionIndex])
				sections[sectionIndex] -= damageLeft
				if sections[sectionIndex] < 0:
					# The hull takes whatever damage the shield section cannot
					hullDamage -= sections[sectionIndex]  # Negative number
					sections[sectionIndex] = 0
			return hullDamage
		else:
			return damage

# Resources
onready var shieldVisual = $ShieldVisual

# Stats
export var baseHealth = 100
export var maxSpeed = 25
export var afterburnerSpeed = 100
#export var afterburnerAcceleration = 100
#export var acceleration = 100
#export var shieldLevel = 1  # Shield capacitor level
export var pitchSpeed = 90  # DPS
export var yawSpeed = 90
export var rollSpeed = 90
#export var mass = 100  # Used to determine damage and knockback
onready var health = baseHealth

# Control
const Pilot = preload("res://Pilot.gd")
const ShipControl = Pilot.ShipControl
var targetVelocity: Vector3 = Vector3(0,0,0)
var controller: Pilot = null
var controlData: Array = [0, 0, 0, 0, false, false]  # See Pilot.ShipControl

# Physics
var velocity: Vector3 = Vector3(0,0,0)
var pitchDelta: float = 0
var yawDelta: float = 0
var rollDelta: float = 0
#var chaseCam: bool = true
onready var actualPitchSpeed = deg2rad(pitchSpeed)
onready var actualYawSpeed = deg2rad(yawSpeed)
onready var actualRollSpeed = deg2rad(rollSpeed)
#onready var throttleDeltaPerSec = .25  # 1/2 of max speed

# Equipment
var shieldUnit = ShieldUnit.new([50, 50])
#var guns = 0  # Change to GunUnit class
#var missiles = 0  # Change to MissileUnit class
#var activeSpecial = 0  # Special ability
var shieldShowTime = 0 setget set_shield_time

# Constants
const X_AXIS = Vector3(1,0,0)
const Y_AXIS = Vector3(0,1,0)
const Z_AXIS = Vector3(0,0,1)


func _floorLowValue(value, threshold = .1):
	if abs(value) < threshold:
		return 0
	return value


func set_shield_time(shieldTime: float):
	if shieldVisual:
		if shieldTime > 0:
			shieldVisual.visible = true
			var shieldMtl = shieldVisual.get_surface_material(0)
			if shieldMtl.has_method("set_shader_param"):
				shieldMtl.set_shader_param("showTime", shieldTime)
		else:
			shieldVisual.visible = false


func _receive_damage(direction: Vector3, position: Vector3, damage: int):
	var damageToTake = damage
	if shieldUnit:
		damageToTake = shieldUnit.absorb(direction, damage)
		if shieldVisual:
			$Tween.interpolate_property(self, ":shieldShowTime", 1.0, 0.0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
			$Tween.start()
			var shieldMtl = $ShieldVisual.get_surface_material(0)
			if shieldMtl.has_method("set_shader_param"):
				print("impactDirection: ", direction)
				shieldMtl.set_shader_param("impactDirection", direction)
				shieldMtl.set_shader_param("impactLocation", position)
	health -= damageToTake


func _process(delta):
	if controller is Pilot:
		controlData = controller.think(delta, controlData)

	pitchDelta = lerp(pitchDelta, actualPitchSpeed * controlData[ShipControl.PITCH], .2)
	pitchDelta = _floorLowValue(pitchDelta)
	yawDelta = lerp(yawDelta, actualYawSpeed * controlData[ShipControl.YAW], .2)
	yawDelta = _floorLowValue(yawDelta)
	rollDelta = lerp(rollDelta, actualRollSpeed * controlData[ShipControl.ROLL], .2)
	rollDelta = _floorLowValue(rollDelta)
	var afterburner = controlData[ShipControl.AFTERBURNER]
	if afterburner:
		targetVelocity.z = afterburnerSpeed
	else:
		targetVelocity.z = controlData[ShipControl.THROTTLE] * maxSpeed


func _physics_process(delta):
	rotate_object_local(X_AXIS, pitchDelta * delta)
	rotate_object_local(Y_AXIS, yawDelta * delta)
	rotate_object_local(Z_AXIS, rollDelta * delta)

	velocity = velocity.rotated(X_AXIS, -pitchDelta * delta)
	velocity = velocity.rotated(Y_AXIS, -yawDelta * delta)
	velocity = velocity.rotated(Z_AXIS, -rollDelta * delta)
	if not controlData[ShipControl.GLIDE]:
		velocity = lerp(velocity, targetVelocity, .03);
	if targetVelocity.x == 0:
		velocity.x = _floorLowValue(velocity.x)
	if targetVelocity.y == 0:
		velocity.y = _floorLowValue(velocity.y)
	if targetVelocity.z == 0:
		velocity.z = _floorLowValue(velocity.z)
	var physvelocity = transform.basis.xform(velocity)
	var collision = move_and_collide(physvelocity * delta)
	if collision != null:
		var obj = collision.collider
		var norm = transform.basis.xform_inv(collision.normal)
		var pos = transform.basis.xform_inv(collision.position)
		#print(collision.collider.name)
		# Bounce
		#if _should_bounce(obj):
		physvelocity = physvelocity.bounce(collision.normal)
		velocity = transform.basis.xform_inv(physvelocity)
		# Do damage
		#if _should_receive_damage(obj):
		var damage = 0
		if obj.has_method("get_damage"):
			damage = obj.get_damage()
		_receive_damage(norm, pos, damage)