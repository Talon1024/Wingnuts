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
			var sectionsDamaged = []
			for section in range(len(sections)):
				var vectorRotation = float(section) / len(sections) * PI * 2
				var sectionVector = Vector3(0,0,1).rotated(Y_AXIS, vectorRotation)
				var sectionDamageFactor = min(0, -direction.dot(sectionVector))
				sectionsDamaged.append(sectionDamageFactor)
			var sectionDamageTotal = 0
			for sectionDamage in sectionsDamaged:
				sectionDamageTotal += sectionDamage
			for sectionIndex in range(len(sectionsDamaged)):
				sectionsDamaged[sectionIndex] /= sectionDamageTotal
			var hullDamage = 0
			return hullDamage
		else:
			return damage


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

var targetVelocity: Vector3 = Vector3(0,0,0)
var velocity: Vector3 = Vector3(0,0,0)

const Pilot = preload("res://Pilot.gd")
const ShipControl = Pilot.ShipControl

var controller: Pilot = null
var controlData: Array = [0, 0, 0, 0, false, false]  # See Pilot.ShipControl
var pitchDelta: float = 0
var yawDelta: float = 0
var rollDelta: float = 0
#var chaseCam: bool = true
onready var health = baseHealth
onready var actualPitchSpeed = deg2rad(pitchSpeed)
onready var actualYawSpeed = deg2rad(yawSpeed)
onready var actualRollSpeed = deg2rad(rollSpeed)
#onready var throttleDeltaPerSec = .25  # 1/2 of max speed

var shieldUnit = ShieldUnit.new([50, 50])
#var guns = 0  # Change to GunUnit class
#var missiles = 0  # Change to MissileUnit class
#var activeSpecial = 0  # Special ability

const X_AXIS = Vector3(1,0,0)
const Y_AXIS = Vector3(0,1,0)
const Z_AXIS = Vector3(0,0,1)


func receiveDamage(direction: Vector3, damage: int):
	var damageToTake = damage
	if shieldUnit:
		damageToTake = shieldUnit.absorb(direction, damage)
	health -= damageToTake


func _process(delta):
	if controller is Pilot:
		controlData = controller.think(delta, controlData)

	pitchDelta = lerp(pitchDelta, actualPitchSpeed * controlData[ShipControl.PITCH], .2)
	yawDelta = lerp(yawDelta, actualYawSpeed * controlData[ShipControl.YAW], .2)
	rollDelta = lerp(rollDelta, actualRollSpeed * controlData[ShipControl.ROLL], .2)
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
	var physvelocity = transform.basis.xform(velocity)
	move_and_collide(physvelocity * delta)