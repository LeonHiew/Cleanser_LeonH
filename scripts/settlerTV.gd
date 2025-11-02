extends Sprite2D

@onready var sicknessInfo: SicknessInformation = null
@export var stats: SettlerStats = load("res://Resources/character_resources/Jacob_settler.tres")
@onready var settlerBook = $"../../SettlerBook"
@onready var healingTankImage = load("res://assets/img/tank/healing.png")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

#call when an a settler has its info updsated
func update():
	texture = stats.settlerChibi
	print(stats.bIsResting)
	if stats.bIsDead == true:
		$Sprite2D.modulate = Color(0.144, 0.141, 0.124, 1.0)
		$".".modulate = Color(0.355, 0.355, 0.355, 1.0)
	elif stats.sickness != sicknessInfo.sickness.notSick:
		$Sprite2D.modulate = Color(0.849, 0.825, 0.0, 1.0)
	elif stats.bIsResting == true:
		$Sprite2D.modulate = Color(0.0, 0.824, 0.26, 1.0)
	else:
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_texture_button_pressed() -> void:
	settlerBook.LoadStats(stats)
	settlerBook.show()
	
func switchHealScreen(settler: SettlerStats):
	if settler == stats:
		#texture = healingTankImage
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)

func switchRestScreen(settler: SettlerStats):
	if settler == stats:
		#texture = healingTankImage
		$Sprite2D.modulate = Color(0.0, 0.824, 0.26, 1.0)
