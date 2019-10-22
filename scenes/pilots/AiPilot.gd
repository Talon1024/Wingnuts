extends "res://scenes/pilots/Pilot.gd"

# Assessment of a target's threat level
class ThreatAssessment:
	var distance: float
	var damage_per_second: float
	var target_type: int

func think(delta, controls: Dictionary) -> Dictionary:
	return controls
