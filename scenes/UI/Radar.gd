extends Node2D
# Radar - displays other ships in relation to the player


const Ship = preload("res://scenes/base/Ship.gd")


var player: Ship
onready var size: Vector2 = $Graphic.texture.get_size() / 2


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


func _ready():
	PlayerInfo.connect("added", self, "_on_player_added")
	PlayerInfo.connect("removed", self, "_on_player_removed")
	Settings.connect("fov_changed", self, "on_fov_changed")
	update()


func _draw():
	var fov_circle = PoolVector2Array([])
	# 32 is the radius of the 180 degree radar circle
	var fov_circle_radius = deg2rad(Settings.fov) / PI * 32
	var fov_circle_circumference = round(fov_circle_radius * TAU) # Circumference
	for point in range(fov_circle_circumference):
		var angle = point / fov_circle_circumference * PI * 2
		fov_circle.append(Vector2(cos(angle), sin(angle)) * fov_circle_radius)
	# Complete the circle
	fov_circle.append(fov_circle[0])
	# draw_circle will fill in the circle
	draw_polyline(fov_circle, Color(0,1,0,1), 1.0, true)


func _process(delta):
	if not player:
		if not $Dots.dots.empty():
			$Dots.dots.clear()
		return
	var other_ships = player.get_parent().get_children()
	for ship in other_ships:
		if (ship != player and
					ship.has_method("_visible_on_radar")):
			_set_dot(ship)


func _set_dot(ship: Ship):
	# Use node path as dictionary key
	var image = ship._visible_on_radar()
	if image:
		var colour = Color(1,0,0,1)
		if ship.alignment == player.alignment:
			colour = Color(0,0,1,1)
		var path = String(ship.get_path())
		$Dots.dots[path] = {
			pos = abs_position_for(player.transform,
				ship.translation, image.get_size()),
			image = image,
			color = colour,
		}


func abs_position_for(source: Transform, target: Vector3, dot_size: Vector2) -> Vector2:
	# De-normalize radar dot position
	return position_for(source, target) * size - (dot_size / 2)


func _on_player_added(ship: Ship):
	player = ship


func _on_player_removed():
	player = null
	$Dots.dots.clear()


func _on_ship_died(ship: Ship):
	# Remove ship from radar
	$Dots.dots.erase(String(ship.get_path()))


func _on_fov_changed():
	update()
