tool
extends LineEdit

const Util := preload("res://addons/c++_helper/util.gd")

onready var script_subdir: String = Util.add_slash(ProjectSettings.get_setting("c++/files/scripts_directory"))\
		+ Util.add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory"))
onready var error: Label = get_node("../../../ScriptError")

var name_of_class := ""
var subdir := ""


func _ready() -> void:
	update_text()


func update_text() -> void:
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name_of_class = Util.to_snake_case(name_of_class)
	text = Util.add_slash(ProjectSettings.get_setting("c++/files/scripts_directory")) + Util.add_slash(subdir) + name_of_class + ".gdns"
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
