#include <Godot.hpp>

using namespace godot;

// Project includes
{class-headers}

// godot_gdnative_init
extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options* o)
{
    godot::Godot::gdnative_init(o);
}

// godot_gdnative_terminate
extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options* o)
{
    godot::Godot::gdnative_terminate(o);
}

// godot_nativescript_init
extern "C" void GDN_EXPORT godot_nativescript_init(void* handle)
{
    godot::Godot::nativescript_init(handle);

{register-classes}
}
