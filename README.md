# Godot C++ Helper Plugin Template

### Prerequisites

You need to have some software installed before you're able to compile this template. Please look at the [Godot documentation page on compiling for your platform](https://docs.godotengine.org/en/stable/development/compiling/index.html#toc-devel-compiling).  
Essentially, you need Scons, the build system, and a C++ compiler for your platform.

### Step-by-step

First you need to clone the repo. This repo makes heavy use of submodules, so you need to clone it in a special way:
```
git clone --recursive https://gitlab.com/godot_cpp_helper_plugin_template.git
```

If you already cloned but forgot the `--recursive` part, just run:
```
git submodule update --init --recursive
```

Now import and open the project in Godot.

**IMPORTANT**: If you're on windows, you must launch Godot from the Visual Studio Developer Command Prompt!  
Make sure you open the **"x64 Native Tools Command Prompt For Visual Studio"** and *not* the regular "Developer Command Prompt for Visual Studio".

The first thing you'll see is the C++ Helper Plugin setup. You don't need to change any of the settings (you shouldn't change any of the file settings), but you can change the style settings if you like.

Next, click the `C++ Build` button at the top-right. The C++ panel should pop up, but no output will appear in the build log until the build finishes. Be patient on the first build, as it will be building the C++ bindings first. It will take much less time on subsequent builds.  
There shouldn't be any errors, but if there are, you may not have installed the prerequisite software correctly (in which case check the Godot documentation again).

If you get a green checkmark on the `C++ Build` button, the build succeeded! Now you can run the example "hello.tscn". Make sure "Hello World!" is printed to the console. If so, you're all set!

Be sure to look at the [Godot documentation page on GDNative C++](https://docs.godotengine.org/en/stable/tutorials/plugins/gdnative/gdnative-cpp-example.html) to learn more about writing the code itself.

