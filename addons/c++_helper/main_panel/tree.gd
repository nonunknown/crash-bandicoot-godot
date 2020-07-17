tool
extends Tree
# Class tree display

signal fs_changed

const Util := preload("res://addons/c++_helper/util.gd")

onready var delete_popup: ConfirmationDialog = $ConfirmationDialog

var subdir_dict: Dictionary


func _ready() -> void:
	refresh()


func custom_sort(a, b) -> bool:
	if a["subdir"] < b["subdir"]:
		return len(a["subdir"]) != 0
	elif a["subdir"] > b["subdir"]:
		return len(b["subdir"]) == 0
	else:
		return a["name"] < b["name"]


func refresh() -> void:
	clear()
	subdir_dict.clear()
	var root := create_item()
	root.set_text(0, "Classes")
	root.set_selectable(0, false)
	var class_info := Util.get_class_info()
	class_info.class_info.sort_custom(self, "custom_sort")
	for info in class_info.class_info:
		if len(info["subdir"]) == 0:
			var c := create_item(root)
			c.set_text(0, info["name"])
		else:
			var paths: PoolStringArray = info["subdir"].split('/', false)
			var prev := root
			for p in paths:
				if not subdir_dict.has(p):
					var subdirnode := create_item(prev)
					subdirnode.set_text(0, p)
					subdirnode.set_selectable(0, false)
					subdir_dict[p] = subdirnode
				prev = subdir_dict[p]
			var c := create_item(prev)
			c.set_text(0, info["name"])


func _on_Tree_visibility_changed() -> void:
	refresh()


# Caled when the delete button is pressed
func _on_Button_pressed() -> void:
	if get_selected() == null:
		return
	
	delete_popup.selected_name = get_selected().get_text(0)
	delete_popup.popup_centered()
	yield(delete_popup, "popup_hide")
	if delete_popup.cancelled == true:
		delete_popup.cancelled = true
		return
	delete_popup.cancelled = true
	
	var s := get_selected()
	var n := s.get_text(0)
	var class_info := Util.get_class_info()
	for i in range(len(class_info.class_info)):
		if class_info.class_info[i]["name"] == n:
			class_info.class_info.remove(i)
			break
	Util.update_gdlibrary()
	ResourceSaver.save(class_info.resource_path, class_info)
	refresh()
	emit_signal("fs_changed")
