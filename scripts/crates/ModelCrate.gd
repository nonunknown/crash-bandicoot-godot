extends Spatial


func _enter_tree():
	if (get_parent().is_animated):
		get_child(0).queue_free()
		generate()
		

func generate():
	var crate = LevelManager.CRATE.instance()
	crate.scale = Vector3.ONE * 0.3
	add_child(crate)
	get_parent().set_animation(crate.get_node("AnimationPlayer"))
	print("is animations")
	pass
