tool
extends LineEdit

const Util := preload("res://addons/c++_helper/util.gd")

onready var header_subdir: String = ProjectSettings.get_setting("c++/files/source_path") + ProjectSettings.get_setting("c++/files/header_subdirectory")
onready var error: Label = get_node("../../../HeaderError")

var name_of_class := ""
var subdir := ""


func _ready() -> void:
	update_text()


func update_text() -> void:
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name_of_class = Util.to_snake_case(name_of_class)
	text = Util.add_slash(header_subdir) + Util.add_slash(subdir) + name_of_class + Util.get_header_extension()
	if not Util.file_exists(text):
		error.visible = true
	else:
		error.visible = false


func _on_ClassName_LineEdit_text_changed(new_text: String) -> void:
	name_of_class = new_text
	update_text()


func _on_Subdir_LineEdit_text_changed(new_text: String) -> void:
	subdir = new_text
	update_text()
