extends Viewport
class_name RadarDisplay


export var radar_size: Vector2 = Vector2(128, 128)


func _ready():
	canvas_transform = Transform2D(Vector2.RIGHT, Vector2.DOWN, radar_size / 2)
