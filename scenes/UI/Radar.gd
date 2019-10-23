extends Node2D
# Radar - displays other ships in relation to the player

onready var root_scene: Node = get_tree().current_scene
onready var player: Spatial = root_scene.get_node("Player")
onready var size: Vector2 = $Graphic.texture.get_size() / 2
const dot_image: Texture = preload("res://assets/UI/HUD/radar_dot.png")

static func position_for(from: Transform, thing_pos: Vector3) -> Vector2:
	"Get normalized 2D radar position for a 3D node from another 3D node"
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

func _process(delta):
	var children = root_scene.get_children()
	var dots = {}
	for spacething in children:
		if (spacething != player and
				spacething.has_method("_visible_on_radar")):
			var dot_image = spacething.call("_visible_on_radar")
			if dot_image:
				dots[spacething] = {
					pos = position_for(
						player.transform, spacething.transform.origin) * size,
					image = dot_image,
					color = Color(1,0,0,1),
				}
	$Dots.dots = dots