#pragma once

#include <Godot.hpp>
#include <Reference.hpp>
#include <Node.hpp>
#include <Array.hpp>
#include <String.hpp>
#include <FuncRef.hpp>

using namespace godot;

class NativeStateMachine : public godot::Reference {
    GODOT_CLASS(NativeStateMachine, godot::Reference)

private:
    uint8_t current_state = -1;
    uint8_t last_state = -1;

    Node* target;
    String* states;
    // NativeStateMachine* child;
    FuncRef* func = FuncRef::_new();
    void _call(String name);
    
public:
    static void _register_methods();

    void _init();
    void register_state(Node* _target, Array keys);
    void change_state(uint8_t state_to);
    void register_child(NativeStateMachine* _child);
    void update();
    uint8_t get_current_state();
    bool last_state_was(uint8_t state);
    bool state_is(uint8_t state);

    NativeStateMachine();
    ~NativeStateMachine();
};
