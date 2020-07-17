tool
extends AcceptDialog

signal update_class_tree
signal warning_dialog_closed(cancel)

const Util := preload("res://addons/c++_helper/util.gd")
const PopupText := "{file-path} already exists. Overwrite?"

onready var name_of_class: LineEdit = $"VBoxContainer2/VBoxContainer/Class Name/LineEdit"
onready var base_class: LineEdit = $"VBoxContainer2/VBoxContainer/Inherits From/LineEdit"
onready var subdir: LineEdit = $"VBoxContainer2/VBoxContainer/Subdirectory/LineEdit"
onready var is_tool: CheckBox = $"VBoxContainer2/VBoxContainer/IsTool/CheckBox"
onready var warning_dialog: ConfirmationDialog = $ConfirmationDialog

var class_name_entered := false
var inherits_entered := true


func _ready() -> void:
	get_ok().text = "Create Class"
	warning_dialog.get_cancel().connect("pressed", self, "_on_ConfirmationDialog_cancelled")


func show_file_warning(path: String) -> void:
	warning_dialog.dialog_text = PopupText.format({"file-path": path})
	warning_dialog.popup_centered()


func reset() -> void:
	if name_of_class:
		name_of_class.text = ""
	if base_class:
		base_class.text = "Node"
	if subdir:
		subdir.text = ""
	if is_tool:
		is_tool.pressed = false


func _on_CreateButton_button_down() -> void:
	var spath := Util.get_source_file_path(name_of_class.text, subdir.text)
	var hpath := Util.get_header_file_path(name_of_class.text, subdir.text)
	
	if Util.file_exists(spath):
		show_file_warning(spath)
		if yield(self, "warning_dialog_closed") == true:
			return
		
	if Util.file_exists(hpath):
		show_file_warning(hpath)
		if yield(self, "warning_dialog_closed") == true:
			return
		
	Util.create_class(name_of_class.text, base_class.text, subdir.text, is_tool.pressed)
	emit_signal("update_class_tree")
	visible = false


func _on_NewClassDialog_visibility_changed() -> void:
	if (visible == false):
		reset()


func _on_ConfirmationDialog_confirmed() -> void:
	emit_signal("warning_dialog_closed", false)


func _on_ConfirmationDialog_cancelled() -> void:
	emit_signal("warning_dialog_closed", true)


func update_button():
	get_ok().disabled = not (class_name_entered and inherits_entered)


func _on_ClassName_text_changed(new_text: String) -> void:
	class_name_entered = len(new_text) > 0
	update_button()


func _on_Inherits_text_changed(new_text: String) -> void:
	inherits_entered = len(new_text) > 0
	update_button()
