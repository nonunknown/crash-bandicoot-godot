# Godot C++ Helper Plugin

![Screenshot](https://gitlab.com/turtlewit/godot_cpp_helper_plugin/-/wikis/uploads/60d25e2dfe05b2d248741c695a386d95/screenshot.png)

Plugin to help with some of the more tedious aspects of developing with GDNative C++.

If you're new to GDNative, please try this [template project](https://gitlab.com/turtlewit/godot_cpp_helper_plugin_template) that requires as little setup as possible!

### Features
* Streamlined class creation:
  * Generate a base header and source file for new classes based on customizable templates.
  * Automatically register new classes in the library entry point.
  * Automatically create the script resource, optionally filling in the script class name.
  * Add generated header and source files to a Visual Studio project.
* Streamlined class deletion:
	* Delete the header, source file, and script file, and remove them from the library entry point and Visual Studio project in one click.
* In-editor build button:
  * Individual build scripts for Linux, OSX, and Windows. 
  * Status indicator showing if the build was successful.
  * Colored build log.

### Installation

**IMPORTANT:** The plugin directory must be named `c++_helper` and be located at `res://addons/c++_helper/`, otherwise the plugin will not work.

The recommended way to install this plugin is as a git submodule.  
With git initialized and from the root of your godot project, enter  
```
mkdir -p addons
git submodule add https://gitlab.com/turtlewit/godot_cpp_helper_plugin.git addons/c++_helper
```  
into your terminal.

Alternatively, you can download a release zip from the releases page. If you do this, simply unzip the contents of the zip file (the `c++_helper` folder itself) into the `res://addons` folder of your godot project.

Once the plugin is installed, open your Godot project in the editor and activate the plugin from the Project Settings, Plugins tab. This will open an initial setup dialog, which will have you set some initial preferences (these can be changed later from the Project Settings).

Once the plugin has been set up, the source, header, and entry point templates will have been generated in the "C++ data directory" (by default `res://addons/c++_helper_data/`).  
To regenerate these templates based on the preferences set in Project Settings, press the Project, Tools, Regenerate C++ Template Files button.

Before using the C++ Build button in the top-right, you have to write a script for your platform in Project Settings (`c++/build_settings/[platform]/build_command`).  
On windows, you are limited to a single line command, but you can use this to run a batch file if you need a more significant build script.  
The working directory for the build script is the root of the project (`res://`).  
There are some additional things you need to worry about when building on Windows. Please read the [building on windows page in the wiki](../../wikis/Building-On-Windows).
