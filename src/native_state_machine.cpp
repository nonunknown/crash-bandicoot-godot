#include "native_state_machine.hpp"

using namespace godot;

void NativeStateMachine::_register_methods()
{
    register_method("register_state", &NativeStateMachine::register_state);
    register_method("change_state", &NativeStateMachine::change_state);
    register_method("update", &NativeStateMachine::update);
    register_method("get_current_state", &NativeStateMachine::get_current_state);
    register_method("last_state_was", &NativeStateMachine::last_state_was);
    register_method("state_is", &NativeStateMachine::state_is);
    register_method("register_child", &NativeStateMachine::register_child);
}

void NativeStateMachine::_init()
{
    is_changing = false;
}

uint8_t NativeStateMachine::get_current_state()
{
    return current_state;
}

bool NativeStateMachine::state_is(uint8_t state)
{
    return state == current_state;
}

bool NativeStateMachine::last_state_was(uint8_t state)
{
    return state == last_state;
}

void NativeStateMachine::update()
{
    func->call_func();
}

void NativeStateMachine::change_state(uint8_t state_to)
{
    _call("st_exit_"+states[current_state]);
    last_state = current_state;
    current_state = state_to; 
    _call("st_init_"+states[current_state]);
    _call("st_update_"+states[current_state]);
}

void NativeStateMachine::register_state(Node* _target, Array keys)
{
    target = _target;
    states = new String[keys.size()];
    func->set_instance(_target);


    for (int i = 0;i<keys.size();i++) {
        states[i] = keys[i];

    }

    current_state = 0;
    last_state = 0;

    _call("st_init_"+states[0]);
    _call("st_update_"+states[0]);
}

void NativeStateMachine::register_child(NativeStateMachine* _child)
{
    child = _child;
}

void NativeStateMachine::_call(String name)
{
    func->set_function(name);
    func->call_func();
    Godot::print(name);
}

NativeStateMachine::NativeStateMachine()
{
}

NativeStateMachine::~NativeStateMachine()
{
}
