extends Node2D

var dots = []

func add_dot(image: Texture, pos: Vector2, color: Color = Color(1,1,1,1)):
	dots.append({image = image, pos = pos, color = color})

func _draw():
	for dot in dots:
		draw_texture(dot.image, dot.pos, dot.color)
	dots.clear()

func _process(delta):
	update()