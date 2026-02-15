extends Control

@onready var center_container: CenterContainer = $CenterContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var manager_computer: Area3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var scale_ratio
    scale_ratio = get_window().size.y / center_container.size.y
    center_container.scale.y = scale_ratio
    center_container.scale.x = scale_ratio


func show_screen():
    animation_player.play("slide")
    show()


func _on_button_pressed() -> void:
    hide()
    manager_computer.give_player_control()
