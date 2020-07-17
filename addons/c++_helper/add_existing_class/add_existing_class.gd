tool
extends AcceptDialog

signal update_class_tree

const Util := preload("res://addons/c++_helper/util.gd")

onready var name_line: LineEdit = $VBoxContainer2/VBoxContainer/ClassName/LineEdit
onready var subdir_line: LineEdit = $VBoxContainer2/VBoxContainer/Subdir/LineEdit
onready var header_line: LineEdit = $VBoxContainer2/VBoxContainer/Header/HBoxContainer/LineEdit
onready var source_line: LineEdit = $VBoxContainer2/VBoxContainer/Source/HBoxContainer/LineEdit
onready var script_line: LineEdit = $VBoxContainer2/VBoxContainer/Script/HBoxContainer/LineEdit
onready var is_tool: CheckBox = $VBoxContainer2/VBoxContainer/IsTool/CheckBox


func _ready() -> void:
	get_ok().text = "Add Class"


func reset() -> void:
	if name_line:
		name_line.text = ""
		name_line.emit_signal("text_changed", "")
	if subdir_line:
		subdir_line.text = ""
		subdir_line.emit_signal("text_changed", "")
	if is_tool:
		is_tool.pressed = false


func _on_Button_pressed() -> void:
	var srcdir: String = ProjectSettings.get_setting("c++/files/source_path")
	if not header_line.text.begins_with(srcdir):
		printerr("Header file is not in " + srcdir + ". Cannot add existing class.")
		return
		
	var class_info := Util.get_class_info()
	var header: String = header_line.text.right(len(srcdir))
	if header[0] == '/':
		header = header.right(1)
	class_info.class_info.append({
		"name": name_line.text,
		"subdir": Util.add_slash(subdir_line.text),
		"header": header,
		"source_path": source_line.text,
		"is_tool": is_tool.pressed,
		"script_path": script_line.text})
	ResourceSaver.save(class_info.resource_path, class_info)
	Util.update_gdlibrary()
	Util.add_class_to_vcxproj(name_line.text, subdir_line.text)
	emit_signal("update_class_tree")
	visible = false
