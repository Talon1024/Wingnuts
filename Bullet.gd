extends KinematicBody

var shooter: KinematicBody
var velocity: Vector3
var lifetime: float = 2.0
var refire: float = 1.0
var speed: float = 6.0
var add_speed: bool = true
onready var distance: float = lifetime * velocity.length()

func _process(delta):
	lifetime -= delta
	if lifetime < 0:
		queue_free()
		return
	var collision = move_and_collide(velocity)

func get_damage() -> int:
	return 7;

func get_refire() -> float:
	return refire