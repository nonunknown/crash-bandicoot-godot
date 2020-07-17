tool
extends ConfirmationDialog

const Util := preload("res://addons/c++_helper/util.gd")

onready var delete_source_files_checkbox: CheckBox = $VBoxContainer/DeleteSourceFiles/CheckBox
onready var delete_script_checkbox: CheckBox = $VBoxContainer/DeleteScript/CheckBox
onready var remove_from_vcxproj_checkbox: CheckBox = $VBoxContainer/RemoveFromVcxproj/CheckBox
onready var remove_from_vcxproj_hbox: HBoxContainer = $VBoxContainer/RemoveFromVcxproj

var selected_name: String
var cancelled: bool = true


func _on_ConfirmationDialog_about_to_show():
	if ProjectSettings.get_setting("c++/files/vcxproj_path") == "":
		remove_from_vcxproj_checkbox.pressed = false
		remove_from_vcxproj_checkbox.disabled = true


func _on_ConfirmationDialog_confirmed():
	cancelled = false
	var delete_source_files := delete_source_files_checkbox.pressed
	var delete_script := delete_script_checkbox.pressed
	var remove_from_vcxproj := remove_from_vcxproj_checkbox.pressed
	
	var class_info := Util.get_class_info_dict(selected_name)
	
	if delete_source_files:
		var source_path: String 
		if class_info.has("source_path"):
			source_path = class_info["source_path"]
		else:
			source_path = Util.get_source_file_path(selected_name, class_info["subdir"])
		var header_path: String = Util.add_slash(ProjectSettings.get_setting("c++/files/source_path")) + class_info["header"]
		Util.delete_file(source_path)
		Util.delete_file(header_path)
	
	if delete_script:
		var script_path: String
		if class_info.has("script_path"):
			script_path = class_info["script_path"]
		else:
			var script_dir_path: String = Util.add_slash(ProjectSettings.get_setting("c++/files/scripts_directory")) + Util.add_slash(class_info["subdir"])
			script_path = script_dir_path + selected_name + ".gdns"
		Util.delete_file(script_path)
	
	if remove_from_vcxproj:
		Util.remove_class_from_vcxproj(selected_name, Util.add_slash(class_info["subdir"]))
	
	hide()
