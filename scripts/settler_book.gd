extends Node2D

signal heal_request(stats : SettlerStats)
signal rest_request(stats : SettlerStats)

var sicknessInfo: SicknessInformation = null
var stats: SettlerStats = null
var healNumber = 1

@onready var play_scene = $"../."

@onready var nameLabel = $BookSprite/NameLabel
@onready var descLabel = $BookSprite/DescLabel
@onready var settlerStats = $BookSprite/SettlerStats
@onready var settlerMoodAndSickness = $"BookSprite/SettlerMood&Sickness"
@onready var deadLabel = $BookSprite/DeadLabel
@onready var smallSprite = $BookSprite/SmallSprite
@onready var bigSprite = $BookSprite/BigSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation


#needs to be called on an instance when its created, loads the resource the 
#card represents
func LoadStats(settlerStats: SettlerStats) -> void:
	stats = settlerStats
	_FillCard()

func _FillCard():
	nameLabel.text = stats.settlerName
	descLabel.text = stats.settlerDesc
	
	var settlerStatText = ""
	
	if stats.foodProduction != 0:
		settlerStatText += "food: %d \n" % [stats.foodProduction]
	if stats.waterProduction != 0:
		settlerStatText += "water: %d  \n" % [stats.waterProduction]
	if stats.ingenuityProduction != 0:
		settlerStatText += "ingenuity: %d  \n" % [stats.ingenuityProduction]
	if stats.militaryProduction != 0:
		settlerStatText += "military: %d  \n" % [stats.militaryProduction]
	settlerStats.text = settlerStatText
	
	var settlerMoodSicknessText = ""
	
	settlerMoodSicknessText += "Current Mood: %s \n" % [
		stats.settlerMoods.find_key(stats.settlerMood)]
	if stats.bIsDead == false:
		settlerMoodSicknessText += "Sickness: %s" % [sicknessInfo.GetNameString(stats.sickness)]
	
	settlerMoodAndSickness.text = settlerMoodSicknessText
	
	
	#show dead label if dead
	if stats.bIsDead == false:
		deadLabel.hide()
	else:
		deadLabel.show()
	
	smallSprite.texture = stats.settlerChibiPortrait
	bigSprite.texture = stats.settlerPortrait
	
	if stats.bIsResting == true:
		$RestButton.disabled = true
	else:
		$RestButton.disabled = false
	
	
	if (play_scene.healNumber == 0):
		$HealButton.disabled  = true
	else:
		$HealButton.disabled  = false
	

func _on_close_button_pressed() -> void:
	$".".hide()

func _on_heal_button_pressed() -> void:
	emit_signal("heal_request", stats)
	$".".hide()

func _on_rest_button_pressed() -> void:
	emit_signal("rest_request", stats)
	$".".hide()
