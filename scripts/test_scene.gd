extends Node2D

@onready var settlerPanel = $settlerPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settlerPanel.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_settler_log_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		settlerPanel.show()
	else:
		settlerPanel.hide()
