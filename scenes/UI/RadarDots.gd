extends Node2D
# Radar dots - displays dots corresponding to enemy ships on the radar


static func position_for(from: Transform, thing_pos: Vector3) -> Vector2:
	# Get normalized 2D radar position for a 3D node from a 3D transform
	var relative_pos = (thing_pos - from.origin).normalized()

	var x = from.basis.x.dot(relative_pos)
	var y = -from.basis.y.dot(relative_pos)
	var z = -from.basis.z.dot(relative_pos)
	# Convert to spherical coordinates
	# https://en.wikipedia.org/wiki/Spherical_coordinate_system#Coordinate_system_conversions
	# var r = Vector3(x, y, z).length()  # Always 1, since relative_pos is normalized
	var angle = atan2(y, x)
	# r will always be 1, so there is no need to divide by r.
	# Also, divide by PI to "normalize" the radius.
	var distance = acos(z) / PI
	# https://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates
	return Vector2(distance * cos(angle), distance * sin(angle))


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship = null
var size: Vector2
var dots = {}


func _ready():
	PlayerInfo.connect("added", self, "_on_player_added")
	PlayerInfo.connect("removed", self, "_on_player_removed")
	if get_parent().has_method("_get_size"):
		size = get_parent().call("_get_size")


func _draw():
	for dot in dots:
		draw_texture(dots[dot].image, dots[dot].pos, dots[dot].color)


func _process(delta):
	if not player:
		if not dots.empty():
			dots.clear()
		return
	var other_ships = player.get_parent().get_children()
	for ship in other_ships:
		if (ship != player and
				ship.has_method("_visible_on_radar")):
			if not ship.is_connected("died", self, "_on_ship_died"):
				ship.connect("died", self, "_on_ship_died", [ship])
			_set_dot(ship)
	update()


func _set_dot(ship: Ship):
	# Use node path as dictionary key
	var node_path = String(ship.get_path())
	var image = ship._visible_on_radar()
	if image:
		var hue = 0
		if ship.forced_dot_hue >= 0:
			hue = ship.forced_dot_hue
		elif ship.alignment == player.alignment:
			hue = .66666666666  # .6666666 = 240 degrees = blue
		var colour = Color().from_hsv(hue, 1, 1, 1)
		dots[node_path] = {
			pos = abs_position_for(player.transform,
				ship.translation, size),
			image = image,
			color = colour,
		}


func abs_position_for(from: Transform, pos: Vector3, size: Vector2):
	return position_for(from, pos) * size


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null
	dots.clear()


func _on_ship_died(ship: Ship):
	var node_path = String(ship.get_path())
	dots.erase(node_path)