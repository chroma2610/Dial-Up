extends Camera3D

@export var manager_view : Vector4
var cafe_view : Vector4
var target_view := cafe_view

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    cafe_view = Vector4(position.x, position.y, position.z, rotation_degrees.x)
    target_view = manager_view


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if target_view != Vector4(position.x, position.y, position.z, rotation.x):
        position = lerp(position, Vector3(target_view.x, target_view.y, target_view.z), delta)
        rotation_degrees.x = lerp(rotation_degrees.x, target_view.w, delta)
