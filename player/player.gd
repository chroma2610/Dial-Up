extends CharacterBody3D

@onready var sprite: AnimatedSprite3D = $sprite
@onready var interaction_cast: ShapeCast3D = $InteractionCast
@onready var camera: Camera3D = $Camera3D
@onready var progress_bar: ProgressBar = $Icons/SubViewport/ProgressBar
@onready var icons: Sprite3D = $Icons

@export var lights_on_modulate : Color
@export var lights_off_modulate : Color
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const GROUND_FRICTION := 0.7

enum states {MOVING, INTERACTING, CARRYING}
var state := states.MOVING
var currently_interacting_with

func _ready() -> void:
    Global.power = true
    state = states.MOVING
    icons.hide()

func _process(delta: float) -> void:
    if Global.power == false:
        sprite.modulate = lights_off_modulate
    else:
        sprite.modulate = lights_on_modulate

func _unhandled_key_input(event: InputEvent) -> void:
    if Global.power == false:
        return
    if Global.day_over == true:
        return
    if not event.is_action_pressed("interact") or state != states.MOVING:
        return
    if not interaction_cast.is_colliding():
        return

    var interacting_object: Node3D = null

    for i in range(interaction_cast.get_collision_count()):
        var collider = interaction_cast.get_collider(i)
        if collider == null:
            continue

        var candidate: Node3D = null
        if collider.has_method("player_interaction"):
            candidate = collider
        elif collider.get_parent() and collider.get_parent().has_method("player_interaction"):
            candidate = collider.get_parent()

        if candidate == null:
            continue

        var candidate_priority = candidate.get("interaction_priority")
        if candidate_priority == null or candidate_priority <= 0:
            continue

        if interacting_object == null:
            interacting_object = candidate
            continue

        var current_priority = interacting_object.get("interaction_priority")
        if current_priority == null:
            current_priority = 0

        if candidate_priority > current_priority:
            interacting_object = candidate

    if interacting_object != null:
        toggle_interaction(interacting_object)


func _physics_process(delta: float) -> void:
    if Global.power == false:
        return
    if Global.day_over == true:
        return
    if position.z < -6:
        camera.target_view = camera.manager_view
    else:
        camera.target_view = camera.cafe_view
    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("left", "right", "up", "down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    handle_ground_movement(direction)
    if state == states.INTERACTING:
        interact()
        

    move_and_slide()
    
func handle_ground_movement(direction):
    if direction and state == states.MOVING:
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

func toggle_interaction(interacting_object):
    state = states.INTERACTING
    currently_interacting_with = interacting_object
    if currently_interacting_with.has_method("start_player_interaction"):
        currently_interacting_with.start_player_interaction()

func interact():
    if currently_interacting_with != null:
        icons.show()
        if state != states.INTERACTING:
            state = states.INTERACTING
            progress_bar.value = 0
        if progress_bar.value < 100:
            progress_bar.value += 1
        else:
            icons.hide()
            progress_bar.value = 0
            currently_interacting_with.player_interaction(self)
            currently_interacting_with = null
    elif Global.power == false:
        icons.hide()
        progress_bar.value = 0
        state = states.MOVING
    
