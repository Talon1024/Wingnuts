extends WorldEnvironment

export var background_panorama_image: Texture = load("res://assets/vendor/ulukai/corona_equirectangular.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	environment.background_sky.panorama = background_panorama_image
