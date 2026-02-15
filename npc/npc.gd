extends AnimatableBody3D
@onready var movement_animator: AnimationPlayer = $AnimationPlayer
@onready var text_animator: AnimationPlayer =$TextAnimator
@onready var label: Label3D = $Label
@export var money_interval := 5
@export var money_amount := 20
@onready var event_timer: Timer = $ProblemTimer
@onready var warning: Sprite3D = $warning
@onready var computers := $"../computers".get_children()

var interaction_priority = 999

enum states {MOVING, COMPUTER, ISSUE, SOLVING}
var state := states.MOVING

var assigned_computer : int
var at_computer : bool
func _ready() -> void:
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
    if anim_name != "walk through door":
        for computer in computers:
            if computer.computer_number == assigned_computer:
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
            warning.show()
            event_timer.stop()
            state = states.ISSUE

func problem_fixed():
    warning.hide()
    event_timer.start()
    state = states.COMPUTER


func _on_text_animator_animation_finished(anim_name: StringName) -> void:
    label.hide()
    
func player_interaction():
    if at_computer == false:
        movement_animator.play(str(assigned_computer))
    elif state == states.ISSUE:
        problem_fixed()
        
    
