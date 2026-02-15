extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    text = "Dear Robert...

Our records indicate that you currently owe us:

[b][u][color=red]"+ "$" + str(Global.total_bills) + "[/color][/u][/b]

We know that you are a robot, but that does NOT excuse you from paying your freakin bills.
If you don't pay this by the end of your shift, we will be forced to shut down your services.

Thanks!
The city utility guys"
