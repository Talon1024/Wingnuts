extends Node3D
# Weapon - controls firing "bullets"


export(PackedScene) var bullet_scene
export(Mesh) var weapon_model


var max_ammo := 0
var ammo := 0
var refire_delay := 0.0
var armed: bool = true


# Add the 3D model for the weapon as a child
func _ready():
	if weapon_model:
		var model = MeshInstance3D.new()
		model.mesh = weapon_model
		add_child(model)


# Arms the weapon
func _arm(arm: bool):
	armed = arm


# Attempts to fire the weapon. Called whenever the pilot of the parent ship
# opens fire. Returns a dictionary specifying whether or not the weapon should
# be fired, as well as what the weapon requires in order to be fired.
# Optionally accepts an "inventory" dictionary, which is what the ship has in
# terms of resources required for firing weapons, such as ammunition.
func _fire(inventory: Dictionary = {}) -> Dictionary:
	if armed and refire_delay == 0.0:
		var bullet = bullet_scene.instance()
		var requirements = {}
		if bullet.has_method("_get_requirements"):
			requirements = bullet._get_requirements()
		if requirements.has("energy") and requirements.energy > inventory.energy:
			return {success = false}
		if requirements.has("ammo") and inventory.ammo < requirements.ammo:
			return {success = false}
		if bullet.has_method("_get_refire"):
			refire_delay = bullet._get_refire()
		bullet.free()
		return {success = true}
	return {success = false}


# Attempts to "unfire" the weapon. Called whenever the pilot of the parent ship
# stops firing. Returns a dictionary specifying whether or not the weapon should
# be fired, as well as what to take away from the parent ship. Useful for
# weapons that charge when the pilot holds the fire button, and fires when the
# fire button is released.
func _unfire(inventory: Dictionary = {}) -> Dictionary:
	return {success = false}


func _process(delta):
	refire_delay = max(0.0, refire_delay - delta)
