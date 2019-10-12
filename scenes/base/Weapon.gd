extends Spatial
# Weapon - controls firing "bullets"

export(PackedScene) var bullet_scene

var refire_delay := 0.0
var armed: bool = true

func _arm(arm: bool):
	armed = arm

func _fire() -> bool:
	if armed and refire_delay == 0.0:
		var bullet = bullet_scene.instance()
		if bullet.has_method("_get_refire"):
			refire_delay = bullet._get_refire()
		bullet.free()
		return true
	return false

func _process(delta):
	refire_delay = max(0.0, refire_delay - delta)