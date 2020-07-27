#include "game_jolt.hpp"

using namespace godot;

void GameJolt::_register_methods()
{
    register_method("_ready", &GameJolt::_ready);
    register_method("_process", &GameJolt::_process);
}

void GameJolt::_init()
{
}

void GameJolt::_ready()
{
}

void GameJolt::_process(float delta)
{
}

GameJolt::GameJolt()
{
}

GameJolt::~GameJolt()
{
}
