extends "res://scenes/pilots/Pilot.gd"

const Spherical = preload("res://scenes/util/spherical.gd")

# Assessment of a target's threat level
class ThreatAssessment:
	var distance: float
	var damage_per_second: float
	var target_type: int

func think(delta, controls: Dictionary) -> Dictionary:
	return controls

func direction_to(target: Vector3) -> Vector2:
	var ship = get_parent()
	var ypr_vec = ship.basis.xform_inv(target)
	var ypr_sph = Spherical.to_spherical(ypr_vec)
	var x_direction = ypr_sph.x
	var y_direction = ypr_sph.y - PI / 2
	return Vector2(x_direction, y_direction)
