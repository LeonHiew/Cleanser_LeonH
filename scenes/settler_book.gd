extends Node2D

signal heal_request(stats : SettlerStats)

var sicknessInfo: SicknessInformation = null
var stats: SettlerStats = null
var healNumber = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation


#needs to be called on an instance when its created, loads the resource the 
#card represents
func LoadStats(settlerStats: SettlerStats) -> void:
	stats = settlerStats
	FillCard()

func FillCard():
	$BookSprite/NameLabelstats.text = stats.settlerName
	$BookSprite/DescLabel.text = stats.settlerDesc
	
	var settlerStatText = ""
	
	if stats.foodProduction != 0:
		settlerStatText += "food: %d \n" % [stats.foodProduction]
	if stats.waterProduction != 0:
		settlerStatText += "water: %d  \n" % [stats.waterProduction]
	if stats.ingenuityProduction != 0:
		settlerStatText += "ingenuity: %d  \n" % [stats.ingenuityProduction]
	if stats.militaryProduction != 0:
		settlerStatText += "military: %d  \n" % [stats.militaryProduction]
	$"BookSprite/SettlerStats".text = settlerStatText
	
	var settlerMoodSicknessText = ""
	
	settlerMoodSicknessText += "Current Mood: %s" %[stats.settlerMood]
	if stats.bIsDead == false:
		settlerMoodSicknessText += "Sickness: %s" % [sicknessInfo.GetNameString(stats.sickness)]
	
	$"BookSprite/SettlerMood&Sickness".text = settlerMoodSicknessText
	
	
	#show dead label if dead
	if stats.bIsDead == false:
		$BookSprite/DeadLabel.hide()
	else:
		$BookSprite/DeadLabel.show()
	

func _on_close_button_pressed() -> void:
	$".".hide()
