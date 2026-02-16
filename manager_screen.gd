extends Node2D

# Drag your GridContainer here in the Inspector
@export var grid: GridContainer
@onready var manager_terminal: TextureRect = $Sprite2D
@onready var inbox: TextureRect = $Inbox
@onready var pay_bills: Button = $Sprite2D/Button
@onready var label: Label = $Sprite2D/Button/Label

# Style knobs (Inspector)
@export var h_separation: int = 24
@export var v_separation: int = 8
@export var font_size: int = 18
@export var name_color: Color = Color.BLACK
@export var value_color: Color = Color.BLACK
@export var name_min_width: int = 0 # 0 = no forced width

# Optional: drag a FontFile / FontVariation here if you want custom font
@export var font: Font

# Optional: value formatting
@export var value_align_right: bool = true

var _value_labels: Dictionary = {} # lets you update single stats later if you want

func _ready() -> void:
    if grid == null:
        push_error("StatsPanel: 'grid' is not assigned in the Inspector.")
        return

    # Make sure the grid is 2 columns
    grid.columns = 2

func set_stats(stats: Dictionary) -> void:
    if grid == null:
        return

    # Apply spacing each time (safe if you change exports at runtime)
    grid.add_theme_constant_override("h_separation", h_separation)
    grid.add_theme_constant_override("v_separation", v_separation)

    # Clear old rows
    for child in grid.get_children():
        child.queue_free()
    _value_labels.clear()

    # Build rows
    for key in stats:
        var name_label := _make_label(str(key), name_color, false)
        if name_min_width > 0:
            name_label.custom_minimum_size.x = name_min_width

        var value_label := _make_label(str(stats[key]), value_color, value_align_right)

        grid.add_child(name_label)
        grid.add_child(value_label)

        _value_labels[key] = value_label

func update_stat(stat_name: String, value) -> void:
    if _value_labels.has(stat_name):
        (_value_labels[stat_name] as Label).text = str(value)

func _make_label(t: String, c: Color, align_right: bool) -> Label:
    var l := Label.new()
    l.text = t

    if align_right:
        l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

    # Use LabelSettings so font size is per-label and easy
    var ls := LabelSettings.new()
    ls.font_size = font_size
    ls.font_color = c
    if font != null:
        ls.font = font
    l.label_settings = ls

    return l


func _process(delta: float) -> void:
    if self.visible:
        set_stats({
        "Total Income": Global.bank_balance,
        "Total Customers": str(Global.total_customers) + "/12",
        "Annoyed Customers": str(Global.customers_with_issues) + "/" + str(Global.total_customers),
        })
    if Global.bank_balance > Global.total_bills:
        pay_bills.disabled = false
        label.hide()
    else: 
        pay_bills.disabled = true
        label.show()
        label.text = "-$" + str(abs(Global.bank_balance - Global.total_bills)) + " short!"


func _on_managerclose_pressed() -> void:
    manager_terminal.hide()


func _on_inboxclose_pressed() -> void:
    inbox.hide()


func _on_manager_terminal_pressed() -> void:
    manager_terminal.show()


func _on_inbox_pressed() -> void:
    inbox.show()


func _on_button_pressed() -> void:
    Global.pay_bills()
