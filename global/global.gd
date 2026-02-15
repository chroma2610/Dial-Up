extends Node

@export var bank_balance := 0.0

@export var occupied_computers := []

@export var total_customers := 0

@export var total_bills := 0.0
var bills := 0.0



func _process(delta: float) -> void:
    bills += delta
    total_bills = roundf(bills * 100) / 100
