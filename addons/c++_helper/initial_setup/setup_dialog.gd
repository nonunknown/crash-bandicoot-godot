tool
extends AcceptDialog

signal done

const Util := preload("res://addons/c++_helper/util.gd")
const ClassInfo := preload("res://addons/c++_helper/class_info/class_info.gd")


func _on_Done_pressed() -> void:
	visible = false


func _on_SetupCDialog_popup_hide() -> void:
	Util.make_dir(Util.add_slash(ProjectSettings.get_setting("c++/files/source_path")))
	Util.make_dir(Util.add_slash(ProjectSettings.get_setting("c++/files/scripts_directory")))
	Util.make_dir(Util.add_slash(ProjectSettings.get_setting("c++/files/source_path")) + ProjectSettings.get_setting("c++/files/cpp_subdirectory"))
	Util.make_dir(Util.add_slash(ProjectSettings.get_setting("c++/files/source_path")) + ProjectSettings.get_setting("c++/files/header_subdirectory"))
	Util.make_dir(Util.add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")))
	
	Util.write_templates()
	
	var class_info_path: String = Util.add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "class_info.tres"
	var class_info_file := File.new()
	if not class_info_file.file_exists(class_info_path):
		var class_info := ClassInfo.new()
		ResourceSaver.save(class_info_path, class_info, ResourceSaver.FLAG_CHANGE_PATH)
	
	var library_path: String = ProjectSettings.get_setting("c++/files/library_path")
	if len(library_path) > 0:
		var library_file := File.new()
		if not library_file.file_exists(library_path):
			var library := GDNativeLibrary.new()
			library.resource_name = library_path
			ResourceSaver.save(ProjectSettings.get_setting("c++/files/library_path"), library, ResourceSaver.FLAG_CHANGE_PATH)
	
	ProjectSettings.set_setting("c++/plugin/plugin_set_up", true)
	ProjectSettings.save()
	
	emit_signal("done")
