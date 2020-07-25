tool
extends EditorPlugin
# Primary plugin script
# Project settings are initialized here, and all plugin scenes are instantiated here.
# build_lib() is called when the C++ Build button is pressed.

const MainPanel = preload("res://addons/c++_helper/main_panel/main_panel.tscn")
const NewClassDialog = preload("res://addons/c++_helper/new_class_dialog/new_class_dialog.tscn")
const SetupDialog = preload("res://addons/c++_helper/initial_setup/setup_c++_dialog.tscn")
const AddExistingDialog = preload("res://addons/c++_helper/add_existing_class/add_existing_class.tscn")
const BuildLog = preload("res://addons/c++_helper/main_panel/build_log.gd")
const Util := preload("res://addons/c++_helper/util.gd")

var main_panel_instance: Control
var new_class_dialog_instance: Popup
var custom_build_button: Button
var setup_dialog_instance: Popup
var add_existing_dialog_instance: Popup
var editor_settings: EditorSettings


# Sets the default value and property hint for a project settings property.
func initialize_project_settings_property(name: String, default_value, type: int, property_hint: int = 0, hint_string: String = "") -> void:
	if not ProjectSettings.has_setting(name):
		ProjectSettings.set_setting(name, default_value)
		ProjectSettings.set_initial_value(name, default_value)
	ProjectSettings.add_property_info({
		"name": name,
		"type": type,
		"hint": property_hint,
		"hint_string": hint_string
	})


# Sets the default value and property hint for an editor settings property (currently unused).
func initialize_editor_settings_property(name: String, default_value, type: int, property_hint: int = 0, hint_string: String = "") -> void:
	if not editor_settings.has_setting(name):
		editor_settings.set_setting(name, default_value)
		editor_settings.set_initial_value(name, default_value, false)
	editor_settings.add_property_info({
		"name": name,
		"type": type,
		"hint": property_hint,
		"hint_string": hint_string
	})


func _enter_tree() -> void:
	editor_settings = get_editor_interface().get_editor_settings()
	
	initialize_project_settings_property("c++/build_settings/X11/build_command", "", TYPE_STRING, PROPERTY_HINT_MULTILINE_TEXT)
	initialize_project_settings_property("c++/build_settings/Windows/build_command", "", TYPE_STRING, PROPERTY_HINT_NONE)
	initialize_project_settings_property("c++/build_settings/OSX/build_command", "", TYPE_STRING, PROPERTY_HINT_MULTILINE_TEXT)
	initialize_project_settings_property("c++/build_settings/clear_output_on_build", true, TYPE_BOOL)
	initialize_project_settings_property("c++/files/source_path", "res://src/", TYPE_STRING, PROPERTY_HINT_DIR)
	initialize_project_settings_property("c++/files/header_subdirectory", "", TYPE_STRING)
	initialize_project_settings_property("c++/files/cpp_subdirectory", "", TYPE_STRING)
	initialize_project_settings_property("c++/files/library_path", "res://library.gdnlib", TYPE_STRING, PROPERTY_HINT_FILE)
	initialize_project_settings_property("c++/files/gdlibrary_source_file_path", "res://src/gdlibrary.cpp", TYPE_STRING, PROPERTY_HINT_FILE)
	initialize_project_settings_property("c++/files/scripts_directory", "res://scripts/", TYPE_STRING, PROPERTY_HINT_DIR)
	initialize_project_settings_property("c++/files/c++_data_directory", "res://addons/c++_helper_data/", TYPE_STRING, PROPERTY_HINT_DIR)
	initialize_project_settings_property("c++/files/vcxproj_path", "", TYPE_STRING, PROPERTY_HINT_FILE)
	initialize_project_settings_property("c++/files/use_script_class_name", true, TYPE_BOOL)
	initialize_project_settings_property("c++/files/snake_case_file_names", true, TYPE_BOOL)
	initialize_project_settings_property("c++/style/use_pragma_once", true, TYPE_BOOL)
	initialize_project_settings_property("c++/style/brace_style", 0, TYPE_INT, PROPERTY_HINT_ENUM, "K&R,1TBS,Allman")
	initialize_project_settings_property("c++/style/header_extension", 0, TYPE_INT, PROPERTY_HINT_ENUM, ".hpp,.h,.hxx,.hh")
	initialize_project_settings_property("c++/style/source_extension", 0, TYPE_INT, PROPERTY_HINT_ENUM, ".cpp,.cxx,.cc")
	initialize_project_settings_property("c++/style/indentation", 0, TYPE_INT, PROPERTY_HINT_ENUM, "Spaces,Tabs")
	
	if not ProjectSettings.has_setting("c++/plugin/plugin_set_up") or ProjectSettings.get_setting("c++/plugin/plugin_set_up") == false:
		initialize_project_settings_property("c++/plugin/plugin_set_up", false, TYPE_BOOL)
		setup_dialog_instance = SetupDialog.instance()
		get_editor_interface().get_editor_viewport().add_child(setup_dialog_instance)
		setup_dialog_instance.popup_centered()
		yield(setup_dialog_instance, "done")

	main_panel_instance = MainPanel.instance()
	add_control_to_bottom_panel(main_panel_instance, "C++")
	make_visible(false)

	new_class_dialog_instance = NewClassDialog.instance()
	get_editor_interface().get_editor_viewport().add_child(new_class_dialog_instance)
	new_class_dialog_instance.connect("update_class_tree", main_panel_instance.get_node("HBoxContainer/Tree"), "refresh")
	
	main_panel_instance.get_node("HBoxContainer/Tree").connect("fs_changed", self, "_on_tree_fs_changed")

	main_panel_instance.get_node("MainPanel/NewClass").connect("pressed", self, "_on_new_class_button_pressed")
	
	custom_build_button = Button.new()
	custom_build_button.text = "C++ Build"
	custom_build_button.connect("pressed", self, "build_lib")
	custom_build_button.connect("pressed", self, "open_tab")
	add_control_to_container(CONTAINER_TOOLBAR, custom_build_button)
	
	add_existing_dialog_instance = AddExistingDialog.instance()
	get_editor_interface().get_editor_viewport().add_child(add_existing_dialog_instance)
	main_panel_instance.get_node("MainPanel/AddExisting").connect("pressed", add_existing_dialog_instance, "popup_centered")
	add_existing_dialog_instance.connect("update_class_tree", main_panel_instance.get_node("HBoxContainer/Tree"), "refresh")

	var regen_button: Button = main_panel_instance.get_node("MainPanel/ReGenerate")
	regen_button.text = "Re-Generate " + ProjectSettings.get_setting("c++/files/gdlibrary_source_file_path").get_file()
	regen_button.connect("pressed", Util, "update_gdlibrary")
	
	add_tool_menu_item("Regenerate C++ Template Files", self, "_on_regenerate_templates_button_pressed")


# Opens the "main_panel_instance" on the bottom panel.
func open_tab() -> void:
	if main_panel_instance:
		make_bottom_panel_item_visible(main_panel_instance)


func _exit_tree() -> void:
	remove_tool_menu_item("Regenerate C++ Template Files")
	if add_existing_dialog_instance:
		add_existing_dialog_instance.queue_free()
	if setup_dialog_instance:
		setup_dialog_instance.queue_free()
	if custom_build_button:
		remove_control_from_container(CONTAINER_TOOLBAR, custom_build_button)
		custom_build_button.queue_free()
	if new_class_dialog_instance:
		new_class_dialog_instance.queue_free()
	if main_panel_instance:
		remove_control_from_bottom_panel(main_panel_instance)
		main_panel_instance.queue_free()


func make_visible(visible: bool):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _on_new_class_button_pressed() -> void:
	new_class_dialog_instance.popup_centered()


# Thread data for when the build button is pressed.
# Needed as to not block the editor while building, but still
# get build output to show in the C++ Build Log.
class BuildThread:
	extends Object
	signal finished
	
	var output: Array
	var ecode: int
	
	func build(userdata: Array) -> void:
		ecode = OS.execute(userdata[0], userdata[1], true, output, true)
		call_deferred("emit_signal", "finished")


func build_lib() -> void:
	var executable := ""
	var args: PoolStringArray
	match OS.get_name():
		"X11":
			executable = "/bin/sh"
			args.append("-c")
		"OSX":
			executable = "/bin/sh"
			args.append("-c")
		"Windows":
			executable = "cmd.exe"
			args.append("/c")
		_:
			Util.oneshot_error_popup(get_editor_interface().get_editor_viewport(), "Cannot build on unsupported platform "\
					+ OS.get_name() + ".\nPlease open an issue on GitLab if you would like this platform to be supported.")
	
	if len(ProjectSettings.get_setting("c++/build_settings/%s/build_command" % OS.get_name())) == 0:
		Util.oneshot_error_popup(get_editor_interface().get_editor_viewport(),\
				"Build command has not been set. Please set the build command in \"Projects->Project Settings...->C++->Build Settings\"")
		return
	
	var bl: BuildLog = main_panel_instance.get_node("HBoxContainer/BuildLog")
	
	if ProjectSettings.get_setting("c++/build_settings/clear_output_on_build") == true:
		bl.clear()
	
	bl.puts("Building project...\n")
	
	# Passing arguments to cmd in windows requires them to be separate list entries, not just separated by spaces.
	if OS.get_name() == "Windows":
		var cmd: String = ProjectSettings.get_setting("c++/build_settings/Windows/build_command")
		var split_cmd := cmd.split("\n")
		split_cmd = cmd.split(" ")
		args += split_cmd
	else:
		args.append(ProjectSettings.get_setting("c++/build_settings/%s/build_command" % OS.get_name()))
	
	var builder := BuildThread.new()
	var thread := Thread.new()
	
	custom_build_button.icon = get_editor_interface().get_base_control().get_icon("Time", "EditorIcons")
	
	thread.start(builder, "build", [executable, args])
	
	yield(builder, "finished")
	
	thread.wait_to_finish()
	
	for line in builder.output:
		bl.puts(line)
		#bl.text += line
	
	if builder.ecode == 0:
		custom_build_button.icon = get_editor_interface().get_base_control().get_icon("StatusSuccess", "EditorIcons")
	else:
		custom_build_button.icon = get_editor_interface().get_base_control().get_icon("StatusError", "EditorIcons")


func _on_regenerate_templates_button_pressed(userdata):
	Util.write_templates()


# Needed to refresh the FileSystem dock, as resources won't be removed instantly otherwise.
func _on_tree_fs_changed() -> void:
	get_editor_interface().get_resource_filesystem().scan()
