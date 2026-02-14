extends AnimatableBody3D
@onready var movement_animator: AnimationPlayer = $AnimationPlayer
@onready var text_animator: AnimationPlayer = $Sprite3D/SubViewport/AnimationPlayer
@onready var label: Label = $Sprite3D/SubViewport/Label
@export var money_interval := 5
@export var money_amount := 20
@onready var event_timer: Timer = $ProblemTimer
enum states {MOVING, COMPUTER, ISSUE, SOLVING}
var state := states.MOVING

var assigned_computer : int
var at_computer : bool
func _ready() -> void:
    state = states.MOVING
    at_computer = false
    randomize()
    assigned_computer = randi_range(1, 12)
    if assigned_computer in Global.occupied_computers:
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
    if anim_name == "walk through door":
        movement_animator.play(str(assigned_computer))
    else:
        for computer in $"../computers".get_children():
            if computer.computer_number == assigned_computer:
                state = states.COMPUTER
                computer.toggle_power()
                at_computer = true
                event_timer.start()

func add_money(money):
    Global.bank_balance += money
    label.text = "+ $" + str(money)
    text_animator.play("RESET")
    text_animator.play("subtle rise")
    


func _on_problem_timer_timeout() -> void:
    print("timeout!")
    if state == states.COMPUTER:
        randomize()
        if randi_range(0, 5) == 3:
            print("PROBLEM")
            event_timer.stop()
            state = states.ISSUE
