extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var flicker_triggered := false

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_accept"):
        Global.turn_off_power()

    if Global.power == false:
        lights_out()

    var should_flicker := Global.power_down_timer > Global.time_until_powerdown / 2

    # Trigger once when condition becomes true
    if should_flicker and not flicker_triggered:
        flicker_triggered = true
        animation_player.play("lightflicker")
        # optional sound:
        # play_flicker()

    # Reset latch when condition is no longer true (so it can fire again later)
    elif not should_flicker:
        flicker_triggered = false


func lights_out():
    for child in get_children():
        if child is OmniLight3D:
            child.light_energy = 0


func toggle_lights():
    for child in get_children():
            if child is OmniLight3D:
                if child.light_energy > 0:
                    child.light_energy = 0
                else: child.light_energy = 0.3

func play_flicker():
    # 1. Create the player
    var player = AudioStreamPlayer.new()
    
    # 2. Load the audio file
    player.stream = load("res://light_flicker.mp3")
    
    # 3. Add to scene (crucial for it to work)
    add_child(player)
    
    # 4. Play and cleanup
    player.play()
    player.finished.connect(player.queue_free) # Remove node when done
