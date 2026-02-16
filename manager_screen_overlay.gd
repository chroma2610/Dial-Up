extends Control

@onready var center_container: CenterContainer = $CenterContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var manager_computer: Area3D = $".."


func _process(delta: float) -> void:
    if Global.power == false or Global.day_over == true:
        hide()
        manager_computer.give_player_control()

func show_screen():
    animation_player.play("slide")
    show()


func _on_button_pressed() -> void:
    hide()
    manager_computer.give_player_control()
