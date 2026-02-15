extends Area3D

@export var computer_number := 0
@export var off_screen_material : StandardMaterial3D
@export var on_screen_material : StandardMaterial3D
@onready var tv: MeshInstance3D = $tv
var interaction_priority = 1
@onready var computer_screen: Control = $ManagerScreenOverlay
var player_node = null
func _ready() -> void:
    tv.set_surface_override_material(1, off_screen_material)
    

func toggle_power():
    if tv.get_surface_override_material(1) == off_screen_material:
        tv.set_surface_override_material(1, on_screen_material)
    else:
        tv.set_surface_override_material(1, off_screen_material)

func player_interaction(player):
    computer_screen.show_screen()
    player_node = player

func give_player_control():
    if player_node != null:
        player_node.state = player_node.states.MOVING
    
