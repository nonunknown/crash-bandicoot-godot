tool
extends MultiMeshInstance

export var extents := Vector2.ONE
export var radius:float = 12

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var theta = 0
	var increase = 1
	var center = get_parent().global_transform.origin
	print(str(increase))
	for i in multimesh.instance_count:
		
		
		var transform := Transform().rotated(Vector3.UP, rng.randf_range(-PI/2, PI/2))
		
		
#		var x := rng.randf_range(-extents.x, extents.x)
#		var z := rng.randf_range(-extents.y, extents.y)
		var x = center.x + (radius + rng.randf_range(0,extents.x) ) * cos(theta)
		var z = center.z + (radius + rng.randf_range(0,extents.y) ) * sin(theta)
		transform.origin = Vector3(x, 0, z)

		multimesh.set_instance_transform(i, transform)
		multimesh.set_instance_custom_data(i, Color(rng.randf(), 0, rng.randf(), 0))
		theta += increase
		


func _on_WindGrass_visibility_changed():
	if visible:
		_ready()
		print("test")
	pass # Replace with function body.
