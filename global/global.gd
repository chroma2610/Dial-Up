extends Node

@export var bank_balance := 0.0

@export var occupied_computers := []

@export var total_customers := 0

@export var customers_with_issues := 0

@export var checking_in := false

@export var total_bills := 0.0

@export var power := true

@export var day := 1

const day_length := 120
var time_left := 0.0
@export var day_over := false

var bills := 0.0
var bill_speed := 0.5

var time_until_powerdown := 100.0
var power_down_timer := 0.0

var timer_on : bool

func _ready() -> void:
    bank_balance = 0
    time_left = day_length

func _process(delta: float) -> void:
    if get_tree().current_scene == null:
        return
    if get_tree().current_scene.name != "main":
        return
    time_left -= delta
    print(time_left)
    bills += delta * bill_speed
    total_bills = roundf(bills * 100) / 100
    
    if bank_balance < total_bills * 0.8 and power == true and bills > 200:
        timer_on = true
    elif bank_balance > total_bills:
        timer_on = false
        power_down_timer = 0.0
    
    if timer_on == true:
        power_down_timer += delta
        if power_down_timer > time_until_powerdown:
            turn_off_power()
            return
    
    if time_left < 0:
        if bank_balance > total_bills:
            day_over = true
        else:
            turn_off_power()
    

func turn_off_power():
    if power == true:
        play_sound("res://power down.mp3")
        power = false
        timer_on = false
        power_down_timer = 0.0
func play_sound(sound_path: String):
    # 1. Create the player
    var player = AudioStreamPlayer.new()
    
    # 2. Load the audio file
    player.stream = load(sound_path)
    
    # 3. Add to scene (crucial for it to work)
    add_child(player)
    
    # 4. Play and cleanup
    player.play()
    player.finished.connect(player.queue_free) # Remove node when done

func pay_bills():
    bills -= clamp(bank_balance, 0, bills)
    bank_balance -= total_bills
    timer_on = false
    power_down_timer = 0.0

func reset():
    bill_speed = 0.5
    day = 1
    bank_balance = 0.0

    occupied_computers = []

    total_customers = 0

    customers_with_issues = 0

    checking_in = false

    total_bills = 0.0

    power = true

    bills = 0.0

    time_until_powerdown = 100.0
    power_down_timer = 0.0

func next_day():
    day_over = false
    time_left = day_length
    bill_speed += 0.25
    day += 1
    occupied_computers = []

    total_customers = 0

    customers_with_issues = 0

    checking_in = false

    total_bills = 0.0

    power = true

    bills = 0.0

    time_until_powerdown = 100.0
    power_down_timer = 0.0
