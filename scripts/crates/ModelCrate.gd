extends Spatial


func _enter_tree():
	if (get_parent().is_animated):
		generate()

func generate():
	var crate = LevelManager.CRATE.instance()
	crate.set_mat_side($MeshInstance.get_surface_material(0))
	crate.set_mat_top($MeshInstance.get_surface_material(1))
	get_child(0).queue_free()
#	var s = crate.get_child(0)
	crate.scale = Vector3.ONE * 0.3
	add_child(crate)
	get_parent().set_animation(crate.get_node("AnimationPlayer"))
	print("is animations")
	pass

onready var initial_top_texture = $MeshInstance.get_surface_material(0).albedo_texture
onready var initial_side_texture = $MeshInstance.get_surface_material(1).albedo_texture


func change_texture(side:Texture, top:Texture):
	$MeshInstance.get_surface_material(0).albedo_texture = side
	$MeshInstance.get_surface_material(1).albedo_texture = top
	pass

func restore_textures():
	$MeshInstance.get_surface_material(0).albedo_texture = initial_side_texture
	$MeshInstance.get_surface_material(1).albedo_texture = initial_top_texture
