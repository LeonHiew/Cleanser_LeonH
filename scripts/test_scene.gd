extends Node2D

@onready var settlerPanel = $settlerPanel

@onready var settlerArray = [
	"res://Resources/character_resources/test_settler.tres",
	]

@export var settlerCard: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settlerPanel.hide()
	for settler in settlerArray:
		var settlerCardInstance = settlerCard.instantiate()
		$settlerPanel/HFlowContainer.add_child(settlerCardInstance)
		
		#loads character sheet based on resource in array
		var stats := load(settler) as SettlerStats
		settlerCardInstance.LoadStats(stats)
		




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_settler_log_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		settlerPanel.show()
	else:
		settlerPanel.hide()
