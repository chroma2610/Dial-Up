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

@export var lights_on_modulate : Color
@export var lights_off_modulate : Color

var annoyed_meter := 0.0
var impatience := 5
@export var annoyed_limit := 100.0

var interaction_priority = 0

enum states {MOVING, WAITING, COMPUTER, ISSUE, LEAVING}
var state := states.MOVING

var assigned_computer_num = null
var assigned_computer = null
var at_computer : bool

var angry := ""

var previous_position : Vector3
func _ready() -> void:
    Global.checking_in = true
    sprite.play("walk")
    previous_position = global_position
    interaction_priority = 0
    label.hide()
    warning.hide()
    state = states.MOVING
    at_computer = false
    randomize()
    assigned_computer_num = randi_range(1, 12)
    while assigned_computer_num in Global.occupied_computers:
        assigned_computer_num = randi_range(1, 12)
    Global.occupied_computers.append(assigned_computer_num)
    movement_animator.play("walk through door")
    
var money_timer := 0.0
func _process(delta: float) -> void:
    if Global.power == false:
        queue_free()
    var difference = global_position - previous_position

    if difference.x > 0:
        sprite.flip_h = true   # moving right
    elif difference.x < 0:
        sprite.flip_h = false    # moving left
    

    previous_position = global_position
    if state == states.COMPUTER:
        active_working(delta)
    elif state == states.ISSUE or state == states.WAITING:
        annoyed_meter += impatience * delta
        if annoyed_meter > annoyed_limit:
            leave()
        elif annoyed_meter > annoyed_limit / 2:
            angry = "angry"
            if sprite.animation == "idle":
                sprite.play("angryidle")
        else: 
            angry = ""
            if sprite.animation == "angryidle":
                sprite.play("idle")
        
        

func active_working(delta):
    if at_computer == true:
        money_timer += delta
        if money_timer >= money_interval:
            print("add money!")
            add_money(money_amount)
            money_timer = 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "walk through door":
        state = states.WAITING
        warning.show()
        interaction_priority = 999
        sprite.play("idle")
    elif state != states.LEAVING:
        for computer in computers:
            if computer.computer_number == assigned_computer_num:
                assigned_computer = computer
                sprite.play("typing")
                interaction_priority = 0
                state = states.COMPUTER
                assigned_computer.toggle_power()
                at_computer = true
                event_timer.start()
    else:
        if assigned_computer != null:
            assigned_computer.toggle_power()
        interaction_priority = 0
        queue_free()

func add_money(money):
    Global.bank_balance += money
    label.text = "+ $" + str(money)
    text_animator.play("RESET")
    label.show()
    text_animator.play("subtle rise")

func _on_problem_timer_timeout() -> void:
    if state == states.COMPUTER:
        if Global.customers_with_issues < 3:
            if randi_range(0, 3) == 1:
                sprite.play(str(angry) + "idle")
                interaction_priority = 999
                warning.show()
                state = states.ISSUE
                event_timer.stop()
                Global.customers_with_issues += 1

func problem_fixed():
    interaction_priority = 0
    sprite.play("typing")
    annoyed_meter -= annoyed_limit * 0.1
    Global.customers_with_issues -= 1
    warning.hide()
    event_timer.start()
    state = states.COMPUTER

func leave():
    sprite.play("angrywalk")
    Global.customers_with_issues -= 1
    warning.hide()
    movement_animator.speed_scale = 0.8
    if state == states.WAITING:
        movement_animator.play("leave")
    else:
        movement_animator.play(str(assigned_computer_num)+"leave")
    state = states.LEAVING
    Global.occupied_computers.erase(assigned_computer_num)
    Global.total_customers -= 1
    assigned_computer_num = null   
    event_timer.stop()


func _on_text_animator_animation_finished(anim_name: StringName) -> void:
    label.hide()
    
func player_interaction(player):
    player.state = states.MOVING
    if at_computer == false:
        warning.hide()
        Global.checking_in = false
        Global.total_customers += 1
        movement_animator.play(str(assigned_computer_num))
        sprite.play("walk")
        annoyed_meter = 0
    elif state == states.ISSUE:
        problem_fixed()

func start_player_interation():
    state = states.COMPUTER
        
    
