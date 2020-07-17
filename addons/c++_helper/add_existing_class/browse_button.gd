tool
extends Button

const Util = preload("res://addons/c++_helper/util.gd")

export(int, 'open_file', 'open_files', 'open_dir', 'open_any', 'save_file') var mode: int
export(int, 'resources', 'userdata', 'filesystem') var access: int
export var filters: PoolStringArray

var file_dialog: FileDialog
var line_edit: LineEdit


func _ready() -> void:
	line_edit = get_node("../LineEdit")
	file_dialog = FileDialog.new()
	add_child(file_dialog)
	file_dialog.mode = mode
	file_dialog.access = access
	file_dialog.filters = filters
	file_dialog.show_hidden_files = true
	file_dialog.connect("file_selected", self, "_on_file_dialog_file_selected")
	file_dialog.resizable = true
	file_dialog.rect_size.y = 400
	connect("pressed", file_dialog, "popup_centered")


func _on_file_dialog_file_selected(file: String):
	var relative = Util.make_relative_path(file)
	if not relative:
		return
	line_edit.text = relative
