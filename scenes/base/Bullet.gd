extends KinematicBody
# Bullet - moves around, runs in to things, and hurts them.
# NOTE: This is not meant to be used directly. Individual weapon types should
# be new scenes inheriting from Bullet.tscn.
#
# Individual weapon types need a CollisionShape, and can optionally override
# _get_requirements to specify what the ship needs to have in order to fire the
# weapon. Note that bullets are, by default, exempt from colliding with their
# respective shooters.

var velocity: Vector3
var lifetime: float = 2.0
var refire: float = 1.0
var speed: float = 200.0
var add_speed: bool = true
# Used for ITTS calculation
onready var distance: float = lifetime * velocity.length()


func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)


# Called by things that can be damaged to retrieve the amount of damage to do
func _get_damage() -> int:
	return 7;


# Called by weapons to see how long it should take before the weapon can be
# fired again
func _get_refire() -> float:
	return refire


func _get_requirements() -> Dictionary:
	return {}
