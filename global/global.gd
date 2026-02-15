extends Node

@export var bank_balance := 0.0

@export var occupied_computers := []

@export var total_customers := 0

@export var customers_with_issues := 0

@export var checking_in := false

@export var total_bills := 0.0
var bills := 0.0



func _process(delta: float) -> void:
    bills += delta * 1
    total_bills = roundf(bills * 100) / 100
