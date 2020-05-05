extends KinematicBody3D
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


func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.has_method("_receive_damage"):
			collision.collider._receive_damage(
				-collision.normal,
				collision.position,
				_get_damage()
			)
			_explode()
			queue_free()


# Called by things that can be damaged to retrieve the amount of damage to do
func _get_damage() -> int:
	return 7;


# Called by weapons to see how long it should take before the weapon can be
# fired again
func _get_refire() -> float:
	return refire


# Spawn explosion
func _explode():
	pass


# Get a dictionary specifying weapon firing requirements. Optionally takes a
# "charge" argument, which is used to calculate the required energy if this
# weapon is a charging weapon.
func _get_requirements(charge: float = 0.0) -> Dictionary:
	return {}
