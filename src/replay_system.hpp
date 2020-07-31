#pragma once

#include <Godot.hpp>
#include <Node.hpp>
#include <Input.hpp>

struct ReplayBuffer
{
    std::uint_fast8_t flags {1 << 5};
    uint64_t frameID;

};


class ReplaySystem : public godot::Node {
    GODOT_CLASS(ReplaySystem, godot::Node)


private:
    Node* target;
    uint64_t currentFrame = 0;
    ReplayBuffer buffers [10];

    std::uint_fast8_t input_up {1 << 0};
    std::uint_fast8_t input_down { 1 << 1};
    std::uint_fast8_t input_left { 1 << 2};
    std::uint_fast8_t input_right { 1 << 3};
    std::uint_fast8_t input_jump { 1 << 4};
    std::uint_fast8_t input_spin { 1 << 5};

public:
    static void _register_methods();
    void _init();
    void _ready();
    void _process(float delta);

    ReplaySystem();
    ~ReplaySystem();
};
