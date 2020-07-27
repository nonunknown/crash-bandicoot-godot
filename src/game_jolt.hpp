#pragma once

#include <Godot.hpp>
#include <Reference.hpp>

class GameJolt : public godot::Reference {
    GODOT_CLASS(GameJolt, godot::Reference)

public:
    static void _register_methods();

    void _init();
    void _ready();
    void _process(float delta);

    GameJolt();
    ~GameJolt();
};
