extends Area3D

@export var computer_number := 0
@export var off_screen_material : StandardMaterial3D
@export var on_screen_material : StandardMaterial3D
@onready var tv: MeshInstance3D = $tv

func _ready() -> void:
    tv.set_surface_override_material(1, off_screen_material)

func toggle_power():
    if tv.get_surface_override_material(1) == off_screen_material:
        tv.set_surface_override_material(1, on_screen_material)
    else:
        tv.set_surface_override_material(1, off_screen_material)
    
