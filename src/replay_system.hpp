#pragma once

#include <Godot.hpp>
#include <Node.hpp>
#include <Input.hpp>
// #include <vector>
#include <list>
#include <bitset>
#include <ctime>
// #include <fstream>
// #include <iostream>
#include <stdio.h>

struct ReplayBuffer
{
    std::bitset<10> flags;
    float frameTime;
    uint64_t frameID;

};

struct ReplayFile
{
    explicit ReplayFile(const std::list<ReplayBuffer>& _buffers = std::list<ReplayBuffer>())
        :_version(1),buffers(_buffers) {
            
        }
    uint16_t _version;
    char* date;
    std::list<ReplayBuffer> buffers;
};

// std::ostream& operator<<(std::ostream& os, const ReplayFile& data) {
//     char* d = new char[data.buffers.size()];
//     for (size_t i = 0; i < data.buffers.size(); i++)
//     {
//         std::list<ReplayBuffer>::const_iterator it = data.buffers.begin();
//         std::advance(it, i);
//         ReplayBuffer rb = *it;
//         ulong c = rb.flags.to_ulong();
//         d[i] = static_cast<char>(c);

        

//     }
    
//     os.write(data,sizeof(data));
//     os.write()
//     // os.write(d,sizeof(d));
//     return os;
// }




class ReplaySystem : public godot::Node {
    GODOT_CLASS(ReplaySystem, godot::Node)


private:
    Node* target;
    uint64_t currentFrame = 0;
    std::list<ReplayBuffer> buffers;
    std::bitset<10> last_flags;
    float time = 0;
    FILE *f;

public:
    static void _register_methods();
    void _init();
    void _ready();
    void _process(float delta);
    void register_frame();
    void print_buffers();
    void WriteReplayFile(const ReplayFile& data);
    void ReadReplayFile();
    ReplaySystem();
    ~ReplaySystem();
};
