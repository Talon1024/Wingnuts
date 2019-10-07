extends Spatial
# Weapon - controls firing "bullets"

export(PackedScene) var bullet_scene

var refire_delay := 0.0
var armed: bool = true

func arm(arm: bool):
	armed = arm

func fire() -> bool:
	if armed and refire_delay == 0.0:
		var bullet = bullet_scene.instance()
		if bullet.has_method("get_refire"):
			refire_delay = bullet.get_refire()
			return true
	return false

func _process(delta):
	refire_delay = max(0.0, refire_delay - delta)