tool
extends RichTextLabel

enum State {
	NONE,
	ESC_BEGIN,
	ESC_PARSING
}

const esc := char(27)
const reset := "0"
const four_bit_colors := {
	'30': '#000000',
	'31': '#cd0000',
	'32': '#00cd00',
	'33': '#cdcd00',
	'34': '#0000ee',
	'35': '#cd00cd',
	'36': '#00cdcd',
	'37': '#e5e5e5',
	'90': '#7f7f7f',
	'91': '#ff0000',
	'92': '#00ff00',
	'93': '#ffff00',
	'94': '#5c5cff',
	'95': '#ff00ff',
	'96': '#00ffff',
	'97': '#ffffff',
}

var inside_color := false


func _ready() -> void:
	set("custom_fonts/normal_font", get_font("mono_font", "EditorFonts"))


func handle_escape(c: String) -> String:
	var ret := ""
	if four_bit_colors.has(c):
		if inside_color == true:
			ret += "[/color]"
		ret += "[color=%s]" % four_bit_colors[c]
		inside_color = true
	elif c == reset:
		if inside_color == true:
			ret += "[/color]"
			inside_color = false
	return ret


func puts(msg: String) -> void:
	var new := ""
	var escape_string := ""
	var state = State.NONE
	for i in range(len(msg)):
		match state:
			State.NONE:
				if msg[i] == esc:
					state = State.ESC_BEGIN
				else:
					new += msg[i]
			State.ESC_BEGIN:
				if msg[i] != '[':
					state = State.NONE
				else:
					state = State.ESC_PARSING
					escape_string = ""
			State.ESC_PARSING:
				if msg[i] == 'm':
					state = State.NONE
					if len(escape_string) == 0:
						new += handle_escape("0")
					else:
						var split_esc := escape_string.split(';', false)
						for e in split_esc:
							new += handle_escape(e)
				elif msg[i].is_valid_integer() || msg[i] == ';':
					escape_string += msg[i]
				else:
					# Unimplemented escape sequence
					#print("C++: Unimplemented Escape Sequence [%s" % escape_string + msg[i])
					state = State.NONE
	bbcode_text += new


func _on_Copy_pressed() -> void:
	var ev = InputEventKey.new()
	ev.pressed = true
	ev.scancode = KEY_C
	ev.control = true
	ev.command = true
	_gui_input(ev)
	


func _on_Clear_pressed() -> void:
	bbcode_text = ""
	inside_color = false
