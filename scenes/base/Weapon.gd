extends Spatial
# Weapon - controls firing "bullets"

export(PackedScene) var bullet_scene

var refire_delay := 0.0
var armed: bool = true


# Arms the weapon
func _arm(arm: bool):
	armed = arm


# Attempts to fire the weapon. Called whenever the pilot of the parent ship
# opens fire. Returns whether or not the weapon should be fired.
func _fire() -> bool:
	if armed and refire_delay == 0.0:
		var bullet = bullet_scene.instance()
		if bullet.has_method("_get_refire"):
			refire_delay = bullet._get_refire()
		bullet.free()
		return true
	return false


# Attempts to "unfire" the weapon. Called whenever the pilot of the parent ship
# stops firing. Returns whether or not the weapon should be fired. Useful for
# weapons that charge when the pilot holds the fire button, and fires when the
# fire button is released.
func _unfire() -> bool:
	return false


func _process(delta):
	refire_delay = max(0.0, refire_delay - delta)