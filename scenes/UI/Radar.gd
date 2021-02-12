extends Node2D
# Radar graphic - displays the radar graphic as a child, and optionally, a
# custom-drawn ring representing the player's FOV


func _ready():
	var me = self as Object
	var fov_changed: Callable = Callable(me, "_on_fov_changed")
	Settings.connect("fov_changed", fov_changed)
	update()


func _draw():
	var fov_circle = PackedVector2Array([])
	# 32 is the radius of the 180 degree radar circle
	var fov_circle_radius = deg2rad(Settings.fov) / PI * 32
	var fov_circle_circumference = round(fov_circle_radius * TAU) # Circumference
	for point in range(fov_circle_circumference):
		var angle = point / fov_circle_circumference * PI * 2
		fov_circle.append(Vector2(cos(angle), sin(angle)) * fov_circle_radius)
	# Complete the circle
	fov_circle.append(fov_circle[0])
	# draw_circle will fill in the circle
	draw_polyline(fov_circle, Color(0,1,0,1), 1.0)


func _get_size() -> Vector2:
	return $Graphic.texture.get_size() / 2


func _on_fov_changed():
	update()
