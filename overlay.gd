extends CanvasLayer

var played := false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button: Button = $TextureRect/Button
@onready var debt: Label = $TextureRect/debt
@onready var balance: Label = $TextureRect/balance
@onready var timer: Timer = $Timer
@onready var label: Label = $Label

func _ready() -> void:
    played = false

func _process(delta: float) -> void:
    if Global.day_over == true and played == false:
        label.text = "Shift #" + str(Global.day + 1)
        played = true
        animation_player.play("nextday")
    if Global.power == false and played == false:
        timer.start()
        played = true
        debt.text = "$" + str(Global.total_bills)
        balance.text = "$" + str(Global.bank_balance)
    
    


func _on_button_pressed() -> void:
    Global.reset()
    get_tree().change_scene_to_file("res://main.tscn")


func _on_timer_timeout() -> void:
    animation_player.play("slide")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
    if anim_name == "nextday":
        Global.next_day()
        get_tree().change_scene_to_file("res://main.tscn")
