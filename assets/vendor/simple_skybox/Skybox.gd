tool
extends Spatial

onready var sky_mesh = preload("res://assets/vendor/ulukai/skyboxu.obj")

export(StreamTexture) var TextureFront = null
export(StreamTexture) var TextureBack = null
export(StreamTexture) var TextureBottom = null
export(StreamTexture) var TextureUp = null
export(StreamTexture) var TextureLeft = null
export(StreamTexture) var TextureRight = null

onready var surfaces = [
	TextureRight,
	TextureBack,
	TextureLeft,
	TextureFront,
	TextureUp,
	TextureBottom,
]


func create_mat(texture):
	var m = SpatialMaterial.new()
	m.flags_unshaded = true
	m.albedo_texture = texture
	# Render skybox behind everything
	m.flags_no_depth_test = true
	m.render_priority = m.RENDER_PRIORITY_MIN
	return m


func _ready():
	var i_mesh = MeshInstance.new()
	i_mesh.cast_shadow = false
	i_mesh.name = "SkyMeshInstance"
	i_mesh.mesh = sky_mesh.duplicate(false)
	add_child(i_mesh)
	for surf in range(len(surfaces)):
		var surfTex = surfaces[surf]
		i_mesh.set_surface_material(surf, create_mat(surfTex))
