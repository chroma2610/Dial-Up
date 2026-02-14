extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        for child in get_children():
            if child is OmniLight3D:
                child.light_energy = 0
