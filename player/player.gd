extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $sprite
@onready var interaction_cast: ShapeCast3D = $InteractionCast
@onready var camera: Camera3D = $Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GROUND_FRICTION := 0.7

func _unhandled_key_input(event: InputEvent) -> void:
    if event.is_action_pressed("interact"):
        if interaction_cast.is_colliding():
            print(interaction_cast.get_collider(0))

func _physics_process(delta: float) -> void:
    if position.z < -6:
        camera.target_view = camera.manager_view
    else:
        camera.target_view = camera.cafe_view
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("left", "right", "up", "down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    
    handle_ground_movement(direction)
    move_and_slide()
    
func handle_ground_movement(direction):
    if direction:
        interaction_cast.target_position = direction
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
