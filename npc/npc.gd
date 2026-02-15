extends AnimatableBody3D
@onready var movement_animator: AnimationPlayer = $AnimationPlayer
@onready var text_animator: AnimationPlayer =$TextAnimator
@onready var label: Label3D = $Label
@export var money_interval := 10
@export var money_amount := 5
@onready var event_timer: Timer = $ProblemTimer
@onready var warning: Sprite3D = $warning
@onready var computers = get_parent().computers.get_children()
@onready var sprite: AnimatedSprite3D = $sprite

var interaction_priority = 0

enum states {MOVING, COMPUTER, ISSUE, SOLVING}
var state := states.MOVING

var assigned_computer : int
var at_computer : bool

var previous_position : Vector3
func _ready() -> void:
    sprite.play("walk")
    previous_position = global_position
    interaction_priority = 0
    label.hide()
    warning.hide()
    state = states.MOVING
    at_computer = false
    randomize()
    assigned_computer = randi_range(1, 12)
    while assigned_computer in Global.occupied_computers:
        assigned_computer = randi_range(1, 12)
    Global.occupied_computers.append(assigned_computer)
    movement_animator.play("walk through door")
    
var money_timer := 0.0
func _process(delta: float) -> void:
    var difference = global_position - previous_position

    if difference.x > 0:
        sprite.flip_h = true   # moving right
    elif difference.x < 0:
        sprite.flip_h = false    # moving left
    
    

    previous_position = global_position
    if state == states.COMPUTER:
        active_working(delta)
        
        

func active_working(delta):
    if at_computer == true:
        money_timer += delta
        if money_timer >= money_interval:
            print("add money!")
            add_money(money_amount)
            money_timer = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "walk through door":
        interaction_priority = 999
        sprite.play("idle")
    else:
        for computer in computers:
            if computer.computer_number == assigned_computer:
                sprite.play("idle")
                interaction_priority = 0
                state = states.COMPUTER
                computer.toggle_power()
                at_computer = true
                event_timer.start()

func add_money(money):
    Global.bank_balance += money
    label.text = "+ $" + str(money)
    text_animator.play("RESET")
    label.show()
    text_animator.play("subtle rise")

func _on_problem_timer_timeout() -> void:
    if state == states.COMPUTER:
        randomize()
        if randi_range(0, 1) == 1:
            interaction_priority = 999
            warning.show()
            event_timer.stop()
            state = states.ISSUE

func problem_fixed():
    print(event_timer.time_left)
    warning.hide()
    event_timer.start()
    state = states.COMPUTER


func _on_text_animator_animation_finished(anim_name: StringName) -> void:
    label.hide()
    
func player_interaction(player):
    player.state = states.MOVING
    if at_computer == false:
        Global.total_customers += 1
        movement_animator.play(str(assigned_computer))
        sprite.play("walk")
    elif state == states.ISSUE:
        problem_fixed()
        
    
