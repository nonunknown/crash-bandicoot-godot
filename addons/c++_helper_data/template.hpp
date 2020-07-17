{top-include-guard}

#include <Godot.hpp>
#include <{base-class}.hpp>

class {class-name} : public godot::{base-class} {
    GODOT_CLASS({class-name}, godot::{base-class})

public:
    static void _register_methods();

    void _init();
    void _ready();
    void _process(float delta);

    {class-name}();
    ~{class-name}();
};{bottom-include-guard}
