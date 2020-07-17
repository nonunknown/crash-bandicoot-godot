extends Object
# Static utility class.
# Doesn't use "class_name" as to not pollute the name space
# for users of the plugin.

const ClassInfo := preload("res://addons/c++_helper/class_info/class_info.gd")
const GdlibraryTemplateTemplate: String = """#include <Godot.hpp>

using namespace godot;

// Project includes
{class-headers}

// godot_gdnative_init
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options* o){brace-newline}{
{indent}godot::Godot::gdnative_init(o);
}

// godot_gdnative_terminate
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options* o){brace-newline}{
{indent}godot::Godot::gdnative_terminate(o);
}

// godot_nativescript_init
extern "C" void GDN_EXPORT godot_nativescript_init(void* handle){brace-newline}{
{indent}godot::Godot::nativescript_init(handle);

{register-classes}
}
"""

const SourceTemplateTemplate: String = """#include "{header-file}"

using namespace godot;

void {class-name}::_register_methods(){brace-newline}{
{indent}register_method("_ready", &{class-name}::_ready);
{indent}register_method("_process", &{class-name}::_process);
}

void {class-name}::_init(){brace-newline}{
}

void {class-name}::_ready(){brace-newline}{
}

void {class-name}::_process(float delta){brace-newline}{
}

{class-name}::{class-name}(){brace-newline}{
}

{class-name}::~{class-name}(){brace-newline}{
}
"""
const HeaderTemplateTemplate: String = """{top-include-guard}

#include <Godot.hpp>
#include <{base-class}.hpp>

class {class-name} : public godot::{base-class}{brace-newline}{
{indent}GODOT_CLASS({class-name}, godot::{base-class})

public:
{indent}static void _register_methods();

{indent}void _init();
{indent}void _ready();
{indent}void _process(float delta);

{indent}{class-name}();
{indent}~{class-name}();
};{bottom-include-guard}
"""


static func create_class(name: String, base_class: String, subpath: String, is_tool: bool) -> void:
	var header_template_path: String = add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "template.hpp"
	var source_template_path: String = add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "template.cpp"
	
	var filename: String
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		filename = to_snake_case(name)
	else:
		filename = name
	
	var header_dir_path: String = add_slash(ProjectSettings.get_setting("c++/files/source_path"))\
			+ add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory")) + add_slash(subpath)
	var source_dir_path: String = add_slash(ProjectSettings.get_setting("c++/files/source_path"))\
			+ add_slash(ProjectSettings.get_setting("c++/files/cpp_subdirectory")) + add_slash(subpath)
	
	var ext_h := get_header_extension()
	var ext_s := get_source_extension()

	var header_path: String = header_dir_path + filename + ext_h
	var source_path: String = source_dir_path + filename + ext_s
	
	make_dir(header_dir_path)
	make_dir(source_dir_path)
	
	# Create the source and header files based on their respective templates.
	var source_template := read_file(source_template_path)
	var header_template := read_file(header_template_path)
	
	var new_source := source_template.format({
		"header-file": add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory")) + filename + ext_h,
		"class-name": name,
	})
	
	var top_include_guard := ""
	var bottom_include_guard := ""
	
	if ProjectSettings.get_setting("c++/style/use_pragma_once") == true:
		top_include_guard = "#pragma once"
	else:
		top_include_guard = """#ifndef {capital-class-name}_HPP
#define {capital-class-name}_HPP""".format({"capital-class-name": to_snake_case(name).to_upper()})
		bottom_include_guard = """
#endif"""
	
	var new_header := header_template.format({
		"top-include-guard": top_include_guard,
		"base-class": base_class,
		"class-name": name,
		"bottom-include-guard": bottom_include_guard,
	})
	
	# Write the new source files.
	overwrite_file(source_path, new_source)
	overwrite_file(header_path, new_header)
	
	var script_dir_path: String = add_slash(ProjectSettings.get_setting("c++/files/scripts_directory")) + add_slash(subpath)
	
	make_dir(script_dir_path)
	
	# Create, fill out, and save the new script resource.
	var script_resource := NativeScript.new()
	script_resource.set("class_name", name)
	script_resource.library = load(ProjectSettings.get_setting("c++/files/library_path"))
	
	if ProjectSettings.get_setting("c++/files/use_script_class_name") == true:
		script_resource.script_class_name = name
	
	ResourceSaver.save(script_dir_path + filename + ".gdns", script_resource, ResourceSaver.FLAG_CHANGE_PATH)
	
	var class_info := get_class_info()
	# Append the class header path and class name to the class_header_paths dictionary.
	class_info.class_info.append({
		"name": name,
		"subdir": add_slash(subpath),
		"header": add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory")) + add_slash(subpath) + filename + ext_h,
		"source_path": source_path,
		"is_tool": is_tool,
		"script_path": script_dir_path + filename + ".gdns"})
	ResourceSaver.save(class_info.resource_path, class_info)
	
	update_gdlibrary()
	
	add_class_to_vcxproj(name, subpath)


static func get_class_info() -> ClassInfo:
	var path: String = ProjectSettings.get_setting("c++/files/c++_data_directory") + "/" + "class_info.tres"
	if not ResourceLoader.exists(path):
		printerr("Class info resource not found! Returning ClassInfo()")
		return ClassInfo.new()
	return load(path) as ClassInfo


static func get_class_info_dict(name: String) -> Dictionary:
	var class_info := get_class_info()
	
	for d in class_info.class_info:
		if d["name"] == name:
			return d
	
	printerr("Could not find class info dict for %s, returning Dictionary()!")
	return Dictionary()


static func write_templates() -> void:
	var gdlibrary_template_path: String = add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "gdlibrary_template.cpp"
	var header_template_path: String = add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "template.hpp"
	var source_template_path: String = add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "template.cpp"
	var function_brace_newline := ""
	var class_brace_newline := ""
	match ProjectSettings.get_setting("c++/style/brace_style"):
		0: # K&R
			function_brace_newline = "\n"
			class_brace_newline = " "
		1: # 1TBS
			function_brace_newline = " "
			class_brace_newline = " "
		2: # Allman
			function_brace_newline = "\n"
			class_brace_newline = "\n"

	var indent = "    "

	if ProjectSettings.get_setting("c++/style/indentation") == 1: # replace spaces with tabs
		indent = "\t"

	var gdlibrary_template_text := GdlibraryTemplateTemplate.format({"brace-newline": function_brace_newline, "indent": indent})
	var source_template_text := SourceTemplateTemplate.format({"brace-newline": function_brace_newline, "indent": indent})
	var header_template_text := HeaderTemplateTemplate.format({"brace-newline": class_brace_newline, "indent": indent})

	overwrite_file(gdlibrary_template_path, gdlibrary_template_text)
	overwrite_file(source_template_path, source_template_text)
	overwrite_file(header_template_path, header_template_text)


static func get_class_headers() -> String:
	var header_string := ""
	
	for info in get_class_info().class_info:
		header_string += "#include \"{path}\"\n".format({"path": info["header"]})
	
	return header_string


static func get_register_classes() -> String:
	var class_names := ""
	var tab_character: String
	if ProjectSettings.get_setting("c++/style/indentation") == 0:
		tab_character = "    "
	else:
		tab_character = "\t"
	
	for info in get_class_info().class_info:
		if info.get("is_tool", false):
			class_names += "{tab-character}register_tool_class<{class-name}>();\n".format({"tab-character": tab_character, "class-name": info["name"]})
		else:
			class_names += "{tab-character}register_class<{class-name}>();\n".format({"tab-character": tab_character, "class-name": info["name"]})
	
	return class_names


static func update_gdlibrary() -> void:
	# Write an updated gdlibrary source file based on the gdlibrary template.
	var gdlibrary_template := read_file(add_slash(ProjectSettings.get_setting("c++/files/c++_data_directory")) + "gdlibrary_template.cpp")

	overwrite_file(ProjectSettings.get_setting("c++/files/gdlibrary_source_file_path"), gdlibrary_template.format({
		"class-headers": get_class_headers(),
		"register-classes": get_register_classes(),
	}))
	
	var relative = make_relative_path(ProjectSettings.get_setting("c++/files/gdlibrary_source_file_path"),\
		add_slash(ProjectSettings.get_setting("c++/files/vcxproj_path").get_base_dir()))
	if relative == null:
		return
	
	add_source_to_vcxproj(relative)


static func oneshot_error_popup(parent: Control, text: String) -> void:
	var error := AcceptDialog.new()
	error.connect("popup_hide", error, "queue_free")
	error.dialog_text = text
	parent.add_child(error)
	error.popup_centered()


# Adds a slash to a directory path if it does not end in a slash.
static func add_slash(t: String) -> String:
	if (len(t) == 0):
		return t
	if not t.ends_with('/'):
		t += '/'
	return t


static func get_header_extension() -> String:
	match ProjectSettings.get_setting("c++/style/header_extension"):
		0:
			return ".hpp"
		1:
			return ".h"
		2:
			return ".hxx"
		3:
			return ".hh"
	return ".hpp"


static func get_source_extension() -> String:
	match ProjectSettings.get_setting("c++/style/source_extension"):
		0:
			return ".cpp"
		1:
			return ".cxx"
		2:
			return ".cc"
	return ".cpp"


static func make_dir(path: String) -> void:
	var dir := Directory.new()
	if OS.get_name() == "Windows" and path.begins_with("res://"): # Work around res://../ not being valid for directories on windows
		path = ProjectSettings.globalize_path("res://") + path.right(len("res://"))
	if not dir.dir_exists(path):
		dir.make_dir_recursive(path)


static func read_file(path: String) -> String:
	var f := File.new()
	f.open(path, File.READ)
	var text := f.get_as_text()
	f.close()
	return text


static func overwrite_file(path: String, text: String) -> void:
	var f := File.new()
	f.open(path, File.WRITE)
	f.store_string(text)
	f.close()


static func file_exists(path: String) -> bool:
	var f := File.new()
	return f.file_exists(path)


static func get_source_file_path(name: String, subdir: String) -> String:
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name = to_snake_case(name)
	return add_slash(ProjectSettings.get_setting("c++/files/source_path"))\
			+ add_slash(ProjectSettings.get_setting("c++/files/cpp_subdirectory"))\
			+ add_slash(subdir) + name + get_source_extension()


static func get_header_file_path(name: String, subdir: String) -> String:
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name = to_snake_case(name)
	return add_slash(ProjectSettings.get_setting("c++/files/source_path"))\
			+ add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory"))\
			+ add_slash(subdir) + name + get_header_extension()


static func add_source_to_vcxproj(path_relative_to_vcxproj: String) -> void:
	var path: String = ProjectSettings.get_setting("c++/files/vcxproj_path")
	
	if path == "":
		return
	
	var contents := read_file(path)
	if contents.find(path_relative_to_vcxproj) != -1:
		return
	
	contents = contents.replace("</Project>", \
"""{indent}<ItemGroup>
{indent}{indent}<ClCompile Include="{path}" />
{indent}</ItemGroup>
</Project>""".format({"path": path_relative_to_vcxproj, "indent": "  "}))
	overwrite_file(path, contents)


static func add_class_to_vcxproj(name: String, subdir: String) -> void:
	var path: String = ProjectSettings.get_setting("c++/files/vcxproj_path")
	
	if path == "":
		return
	
	var relative = make_relative_path(add_slash(ProjectSettings.get_setting("c++/files/source_path")),\
		add_slash(ProjectSettings.get_setting("c++/files/vcxproj_path").get_base_dir()))
	
	if relative == null:
		return
	
	var rpath: String = relative
	
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name = to_snake_case(name)
		
	var contents := read_file(path)
	if contents.find(add_slash(subdir) + name) != -1:
		return
	
	contents = contents.replace("</Project>", \
"""{indent}<ItemGroup>
{indent}{indent}<ClCompile Include="{rpath}{ssub}{subdir}{name}{s-ext}" />
{indent}{indent}<ClInclude Include="{rpath}{hsub}{subdir}{name}{h-ext}" />
{indent}</ItemGroup>
</Project>""".format({"rpath": rpath, "subdir": add_slash(subdir), "name": name,\
			"ssub": add_slash(ProjectSettings.get_setting("c++/files/cpp_subdirectory")),\
			"hsub": add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory")),\
			"s-ext": get_source_extension(), "h-ext": get_header_extension(),\
			"indent": "  "}))
	overwrite_file(path, contents)


static func remove_class_from_vcxproj(name: String, subdir: String) -> void:
	var path: String = ProjectSettings.get_setting("c++/files/vcxproj_path")
	
	if path == "":
		return
		
	var relative = make_relative_path(add_slash(ProjectSettings.get_setting("c++/files/source_path")),\
		add_slash(ProjectSettings.get_setting("c++/files/vcxproj_path").get_base_dir()))
	
	if relative == null:
		return
	
	var rpath: String = relative
	
	if ProjectSettings.get_setting("c++/files/snake_case_file_names") == true:
		name = to_snake_case(name)
		
	var contents := read_file(path)
	if contents.find(add_slash(subdir) + name) == -1:
		return
	
	var lines_to_remove = """{indent}{indent}<ClCompile Include="{rpath}{ssub}{subdir}{name}{s-ext}" />
{indent}{indent}<ClInclude Include="{rpath}{hsub}{subdir}{name}{h-ext}" />"""\
			.format({"rpath": rpath, "subdir": add_slash(subdir), "name": name,\
			"ssub": add_slash(ProjectSettings.get_setting("c++/files/cpp_subdirectory")),\
			"hsub": add_slash(ProjectSettings.get_setting("c++/files/header_subdirectory")),\
			"s-ext": get_source_extension(), "h-ext": get_header_extension(),\
			"indent": "  "}).split("\n")
	contents = contents.replace(lines_to_remove[0] + "\n", "").replace(lines_to_remove[1] + "\n", "")
	contents = contents.replace("  <ItemGroup>\n  </ItemGroup>\n", "") # Remove stray empty item groups
	
	overwrite_file(path, contents)


static func delete_file(path: String) -> void:
	var dir := Directory.new()
	dir.remove(path)


static func make_relative_path(path: String, from: String = "res://"):
	if from == "res://" && path.begins_with("res://"):
		return path
	if path == from:
		return ""
	if len(path) == 0:
		return ""
	
	var path_to_res := ProjectSettings.globalize_path(from).split("/", false)
	var split_path := ProjectSettings.globalize_path(path).split("/", false)
	if len(split_path) == 0:
		return ""
	if OS.get_name() == "Windows":
		if len(path_to_res) == 0:
			printerr("Can't find absolute path to res:// for some reason. Open an issue?")
			return null
		if path_to_res[0].to_lower() != split_path[0].to_lower():
			printerr("No relative path from %s to %s!" % [from, path])
			return null
		path_to_res.remove(0)
		split_path.remove(0)
	
	var case_sensitive = true;
	if OS.get_name() in ["Windows", "OSX"]:
		case_sensitive = false;
	
	var number_same := 0
	
	for i in range(min(len(split_path), len(path_to_res))):
		var a: String = path_to_res[i]
		var b: String = split_path[i]
		if not case_sensitive:
			a = a.to_lower()
			b = b.to_lower()
		if a != b:
			break
		number_same += 1
	
	var ret_path := PoolStringArray()
	
	for i in range(len(path_to_res) - number_same):
		ret_path.append("..")
	
	for i in range(len(split_path) - number_same):
		ret_path.append(split_path[number_same + i])
	
	if path.ends_with("/"):
		ret_path.append("")
	if from == "res://":
		return (PoolStringArray(["res:/"]) + ret_path).join("/")
	return ret_path.join("/")


static func to_snake_case(from: String) -> String:
	if len(from) == 0:
		return from
	
	var new := ""
	new += from[0].to_lower()
	var previous_capitals := 0
	if new[0] != from[0]:
		previous_capitals = 1
	for i in range(1, len(from)):
		if from[i].to_lower() != from[i]:
			if previous_capitals == 0:
				new += "_" + from[i].to_lower()
				previous_capitals = 1
			else:
				new += from[i].to_lower()
				previous_capitals += 1
		else:
			if previous_capitals > 1:
				new = new.insert(len(new) - 1, "_")
			previous_capitals = 0
			new += from[i]
	
	return new
