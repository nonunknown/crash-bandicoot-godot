#include "replay_system.hpp"

using namespace godot;

void ReplaySystem::_register_methods()
{
    register_method("_ready", &ReplaySystem::_ready);
    register_method("_process", &ReplaySystem::_process);
    register_method("register_frame", &ReplaySystem::register_frame);
    register_method("print_buffers", &ReplaySystem::print_buffers);
}

void ReplaySystem::_init()
{
}
void ReplaySystem::_ready()
{

}

void ReplaySystem::WriteReplayFile(const ReplayFile& data)
{
    FILE *fout = fopen("replay.cdr","w") , f;
    fwrite(&data, sizeof(data), 1, fout);
    fclose(fout);

    // std::ofstream file;
    // file.open("replay.cdr", std::ofstream::out);
    // file << data._version;
    // file.close();


};

void ReplaySystem::ReadReplayFile()
{
    FILE *fin = fopen("replay.cdr","r");
    struct ReplayFile* rf;

    fread(&rf, sizeof(ReplayFile), 1, fin);
    Godot::print("printing file data version");
    std::string s = std::to_string(rf->_version);
    s += " | "+std::to_string(rf->buffers.size());
    Godot::print(godot::String(s.c_str()));
}

void ReplaySystem::_process(float delta)
{
    time += delta;
    Input* input = Input::get_singleton();
    if (input->is_action_just_pressed("cmd_time")) {
        WriteReplayFile(ReplayFile(buffers));
        Godot::print("saved, now reading");
        ReadReplayFile();

    }
}
void ReplaySystem::register_frame()
{
    ReplayBuffer buffer;
    buffer.frameID = currentFrame;
    buffer.frameTime = time;

    Input* input = Input::get_singleton();
    if (input->is_action_just_pressed("ui_down")) {
        buffer.flags |= 1 << 0;
        Godot::print("Pressed down");
    }
    if (input->is_action_just_pressed("ui_up")) buffer.flags |= 1 << 1;
    if (input->is_action_just_pressed("ui_left")) buffer.flags |= 1 << 2;
    if (input->is_action_just_pressed("ui_right")) buffer.flags |= 1 << 3;

    if (input->is_action_just_released("ui_down")) buffer.flags |= 1 << 4;
    if (input->is_action_just_released("ui_up")) buffer.flags |= 1 << 5;
    if (input->is_action_just_released("ui_left")) buffer.flags |= 1 << 6;
    if (input->is_action_just_released("ui_right")) buffer.flags |= 1 << 7;

    if (input->is_action_just_pressed("cmd_spin")) buffer.flags |= 1 << 8;
    if (input->is_action_just_pressed("ui_select")) buffer.flags |= 1 << 9;

    if (last_flags == buffer.flags) return;
    buffers.push_back(buffer);
    std::string s = buffer.flags.to_string();
    Godot::print(godot::String(s.c_str()));

    // buffers[0] = buffer;

    currentFrame++;
    last_flags = buffer.flags;

    
}



void ReplaySystem::print_buffers()
{
    std::string s = "";
    for (size_t i = 0; i < buffers.size(); i++)
    {
        std::list<ReplayBuffer>::iterator it = buffers.begin();
        std::advance(it,i);
        ReplayBuffer rb = *it;
        s += rb.flags.to_string() + " | ";
    }
    
    Godot::print(godot::String(s.c_str()));
}


ReplaySystem::ReplaySystem()
{
}

ReplaySystem::~ReplaySystem()
{
}
