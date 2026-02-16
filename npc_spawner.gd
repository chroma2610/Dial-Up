extends Node3D


@export var scene: PackedScene

@onready var computers: Node3D = $"../computers"

var spawn_timer := 0.0
var spawn_interval

func _ready() -> void:
    randomize()
    spawn_interval = randf_range(0, 20)
    spawn()

func _process(delta: float) -> void:
    if Global.power == false:
        return
    if Global.checking_in == true or len(get_children()) > 11:
        spawn_timer = 0
        pass
    elif spawn_timer > spawn_interval:
        spawn()
        spawn_timer = 0
        randomize()
        spawn_interval = randf_range(0, 20)
    else:
        spawn_timer += delta



func spawn():
    var inst := scene.instantiate()
    self.add_child(inst)


var running = false
func spawn_continuously(delay: float):
    running = true
    while running == true:
        await get_tree().create_timer(delay).timeout
        spawn()
            
        
