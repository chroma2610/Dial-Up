extends Label


func _process(delta: float) -> void:
    text = str(Global.bank_balance)
