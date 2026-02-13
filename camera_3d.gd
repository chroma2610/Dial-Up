extends Camera3D

@onready var player: CharacterBody3D = $"../player"
@export var target_position := wide_view

const wide_view := Vector3(0, 5.348, 8.223)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
    if target_position != global_position:
        global_position = lerp(global_position, target_position, delta)
