tool
extends Node

export var options: String
export var project_settings_name: String


func _ready() -> void:
	get_parent().connect("item_selected", self, "_on_OptionButton_item_selected")
	get_parent().clear()
	for option in options.split(','):
		get_parent().add_item(option)
	get_parent().selected = ProjectSettings.get_setting(project_settings_name)


func _on_OptionButton_item_selected(id: int) -> void:
	ProjectSettings.set_setting(project_settings_name, id)
