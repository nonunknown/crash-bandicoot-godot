tool
extends TextEdit

export var project_setting_name: String


func _on_TextEdit_text_changed() -> void:
	ProjectSettings.set_setting(project_setting_name, text)
