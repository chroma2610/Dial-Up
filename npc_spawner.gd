extends Node3D


@export var scene: PackedScene

@onready var computers: Node3D = $"../computers"

func _ready() -> void:
        spawn()

func _process(delta: float) -> void:
    if len(get_children()) < 12:
        running = true
    else:
        running = false

func spawn():
    var inst := scene.instantiate()
    self.add_child(inst)
    inst.global_position = global_position


var running = false
func spawn_continuously(delay: float):
    running = true
    while running == true:
        
        spawn()
            
        await get_tree().create_timer(delay).timeout
