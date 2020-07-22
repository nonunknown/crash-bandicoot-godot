extends CrateItem
class_name CrateWumpa

export var random_amt:bool = false
export var amt_wumpa:int = 5

var ps_wumpa:PackedScene = preload("res://gameplay/items/obj_item_wumpa.tscn")

func on_crate_destroy():
	for i in range(amt_wumpa):
		var wumpa:Item = ps_wumpa.instance()
		get_parent().add_child(wumpa)
		wumpa.global_transform.origin = global_transform.origin + Vector3(0,10,0)
