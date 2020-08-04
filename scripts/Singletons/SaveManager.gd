extends Node

const save_path:String = "res://dat.res"

func get_base_data() -> SaveResource:
	return SaveResource.new()

func save_game(data:SaveResource):
	print( str( data.warp_1))
	var error = ResourceSaver.save(save_path, data,32)
	print("error = "+ str(error))
	pass

func load_game() -> SaveResource:
	var data:SaveResource = load(save_path)
	print(data.print_me())
	return data
