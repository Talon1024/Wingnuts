extends Spatial
# Weapon - controls firing "bullets"


export(PackedScene) var bullet_scene
export(Mesh) var weapon_model


var ammunition := 0
var refire_delay := 0.0
var armed: bool = true


# Add the 3D model for the weapon as a child
func _ready():
	if weapon_model:
		var model = MeshInstance.new()
		model.mesh = weapon_model
		add_child(model)


# Arms the weapon
func _arm(arm: bool):
	armed = arm


# Attempts to fire the weapon. Called whenever the pilot of the parent ship
# opens fire. Returns whether or not the weapon should be fired.
# Optionally pass the amount of energy the ship has to this method.
func _fire(energy: float = 0.0) -> bool:
	if armed and refire_delay == 0.0:
		var bullet = bullet_scene.instance()
		var requirements = {}
		if bullet.has_method("_get_requirements"):
			requirements = bullet._get_requirements()
		if requirements.has("energy") and requirements.energy > energy:
			return false
		if requirements.has("ammo") and ammunition < requirements.ammo:
			return false
		if bullet.has_method("_get_refire"):
			refire_delay = bullet._get_refire()
		bullet.free()
		return true
	return false


# Attempts to "unfire" the weapon. Called whenever the pilot of the parent ship
# stops firing. Returns whether or not the weapon should be fired. Useful for
# weapons that charge when the pilot holds the fire button, and fires when the
# fire button is released.
func _unfire(energy: float = 0.0) -> bool:
	return false


func _process(delta):
	refire_delay = max(0.0, refire_delay - delta)