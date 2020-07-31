#include "replay_system.hpp"

using namespace godot;

void ReplaySystem::_register_methods()
{
    register_method("_ready", &ReplaySystem::_ready);
    register_method("_process", &ReplaySystem::_process);
}

void ReplaySystem::_init()
{
}
void ReplaySystem::_ready()
{

}

void ReplaySystem::_process(float delta)
{
    ReplayBuffer buffer;
    buffer.frameID = currentFrame;
    buffer.flags |= input_down;
    // bool down = Input::is_action_just_pressed("cmd_down");
    buffers[0] = buffer;

    currentFrame++;
}


ReplaySystem::ReplaySystem()
{
}

ReplaySystem::~ReplaySystem()
{
}
