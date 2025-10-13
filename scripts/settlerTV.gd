extends Sprite2D

@onready var sicknessInfo: SicknessInformation = null
@export var stats: SettlerStats = load("res://Resources/character_resources/Jacob_settler.tres")
@onready var settlerBook = $"../../SettlerBook"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

#call when an a settler has its info updated
func update():
	if stats.bIsDead == true:
		$Sprite2D.modulate = Color(0.144, 0.141, 0.124, 1.0)
		$".".modulate = Color(0.355, 0.355, 0.355, 1.0)
	elif stats.sickness != sicknessInfo.sickness.notSick:
		$Sprite2D.modulate = Color(0.849, 0.825, 0.0, 1.0)
	else:
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_texture_button_pressed() -> void:
	settlerBook.LoadStats(stats)
	settlerBook.show()
