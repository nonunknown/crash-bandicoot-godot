tool
extends Button

const Util = preload("res://addons/c++_helper/util.gd")

export var project_setting_name: String
export(int, 'open_file', 'open_files', 'open_dir', 'open_any', 'save_file') var mode: int
export(int, 'resources', 'userdata', 'filesystem') var access: int
export var filters: PoolStringArray

onready var path_label: LineEdit = get_node("../HBoxContainer/Label2")

var file_dialog: FileDialog


func _ready() -> void:
	file_dialog = FileDialog.new()
	add_child(file_dialog)
	file_dialog.mode = mode
	file_dialog.access = access
	file_dialog.filters = filters
	file_dialog.show_hidden_files = true
	file_dialog.connect("file_selected", self, "_on_FileDialog_selected")
	file_dialog.connect("dir_selected", self, "_on_FileDialog_selected")
	file_dialog.resizable = true
	file_dialog.rect_size.y = 400
	connect("pressed", file_dialog, "popup_centered")
	
	path_label.text = ProjectSettings.get_setting(project_setting_name)


func _on_FileDialog_selected(selected: String) -> void:
	if mode == FileDialog.MODE_OPEN_DIR:
		if not selected.ends_with('/'):
			selected += '/'
	var relative = Util.make_relative_path(selected)
	if not relative:
		return
	path_label.text = relative
	ProjectSettings.set_setting(project_setting_name, relative)
