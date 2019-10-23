extends Node2D

var dots = {}

func _draw():
	for dot in dots:
		draw_texture(dots[dot].image, dots[dot].pos, dots[dot].color)

func _process(delta):
	update()