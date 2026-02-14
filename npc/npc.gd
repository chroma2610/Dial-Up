extends AnimatableBody3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var assigned_computer : int

func _ready() -> void:
    randomize()
    assigned_computer = randi_range(1, 4)
    print(assigned_computer)
    animation_player.play("walk through door")
    
    


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "walk through door":
        animation_player.play(str(assigned_computer))
    else:
        for computer in $"../computers".get_children():
            if computer.computer_number == assigned_computer:
                computer.toggle_power()
