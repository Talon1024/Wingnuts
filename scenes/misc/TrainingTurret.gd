extends Spatial


const Intercept = preload("res://scenes/util/intercept.gd")


onready var refire_delay = 0
onready var target = get_node("../Player")
export(PackedScene) var projectile


func _process(delta: float):
	if refire_delay <= 0 and target:
		fire(delta, target)
		refire_delay = 1
	else:
		refire_delay -= delta


func fire(delta: float, target: Spatial):
	# Fire at player
	var to_target = target.global_transform.origin - global_transform.origin
	var bullet = projectile.instance()
	var global_target_velocity = target.global_transform.basis.xform(target.velocity)
	var intercept_time = Intercept.get_lead_time(to_target, global_target_velocity * delta, bullet.speed * delta)
	var lead_point = target.global_transform.origin + global_target_velocity * intercept_time * delta
	var to_lead_point = lead_point - global_transform.origin
	bullet.global_transform = global_transform
	bullet.velocity = to_lead_point.normalized() * bullet.speed
	get_parent().add_child(bullet)
