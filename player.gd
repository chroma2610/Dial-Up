extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $sprite

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GROUND_FRICTION := 0.7


func _physics_process(delta: float) -> void:
    
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    handle_ground_movement(direction)
    move_and_slide()
    
func handle_ground_movement(direction):
    if direction:
        if direction.x > 0: sprite.flip_h = true
        elif direction.x < 0: sprite.flip_h = false
        sprite.play("walk")
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
    else:
        sprite.play("idle")
        var v = Vector2(velocity.x, velocity.z)
        v = v.move_toward(Vector2.ZERO, GROUND_FRICTION)
        velocity.x = v.x
        velocity.z = v.y
