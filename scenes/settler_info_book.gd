extends Node2D

var sicknessInfo: SicknessInformation = null
var stats: SettlerStats = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation



#needs to be called on an instance when its created, loads the 
#resource the bokk represents
func LoadStats(settlerStats: SettlerStats) -> void:
	stats = settlerStats
	FillCard()

#fills the book labels with the stats from its currently
#loaded resource
func FillCard() -> void:
	pass
