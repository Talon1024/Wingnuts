extends Node2D
# Radar - displays other ships in relation to the player


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship
onready var size: Vector2 = $Graphic.texture.get_size() / 2


static func position_for(from: Transform, thing_pos: Vector3) -> Vector2:
	# Get normalized 2D radar position for a 3D node from a 3D transform
	var relative_right = from.basis.xform(Vector3.RIGHT)
	var relative_down = from.basis.xform(Vector3.DOWN)
	var relative_fwd = from.basis.xform(Vector3.FORWARD)

	var relative_pos = (thing_pos - from.origin).normalized()

	var x = relative_right.dot(relative_pos)
	var y = relative_down.dot(relative_pos)
	var z = relative_fwd.dot(relative_pos)
	# Convert to spherical coordinates
	# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Coordinate_system_conversions
	# var r = Vector3(x, y, z).length()  # Always 1, since relative_pos is normalized
	var angle = atan2(y, x)
	# r will always be 1, so there is no need to divide by r.
	# Also, divide by PI to "normalize" the radius.
	var distance = acos(z) / PI
	# https://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates
	return Vector2(distance * cos(angle), distance * sin(angle))


func _ready():
	PlayerInfo.connect("added", self, "_on_player_added")
	PlayerInfo.connect("removed", self, "_on_player_removed")


func _process(delta):
	if not player:
		return
	var player_scene = player.get_parent()
	var children = player_scene.get_children()
	for spacething in children:
		if (spacething != player and
					spacething.has_method("_visible_on_radar")):
			var dot_image = spacething.call("_visible_on_radar")
			if dot_image:
				var iff_colour = Color(1,0,0,1)
				if spacething.alignment == player.alignment:
					iff_colour = Color(0,0,1,1)
				$Dots.dots[spacething] = {
					pos = abs_position_for(
							player.transform, spacething.translation,
							dot_image.get_size()),
					image = dot_image,
					color = iff_colour,
				}


func abs_position_for(source: Transform, target: Vector3, dot_size: Vector2) -> Vector2:
	# De-normalize radar dot position
	return position_for(source, target) * size - (dot_size / 2)


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null
	$Dots.dots.clear()