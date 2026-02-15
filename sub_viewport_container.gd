extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    scale = Vector2(get_window().size)
    print(scale)
