extends Panel

var sicknessInfo: SicknessInformation = null
var stats: SettlerStats = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#needs to be called on an instance when its created, loads the resource the 
#card represents
func LoadStats(settlerStats: SettlerStats) -> void:
	stats = settlerStats
	FillCard()

#fills the  cards label with the stats from its currently loaded resource
func FillCard() -> void:
	var fillText = """ %s 
	%s 
	Stats 
	"""% [
		stats.settlerName,
		stats.settlerDesc
		]
	
	if stats.foodProduction != 0:
		fillText += "food: %d \n" % [stats.foodProduction]
	if stats.waterProduction != 0:
		fillText += "water: %d  \n" % [stats.waterProduction]
	if stats.ingenuityProduction != 0:
		fillText += "ingenuity: %d  \n" % [stats.ingenuityProduction]
	if stats.militaryProduction != 0:
		fillText += "military: %d  \n" % [stats.militaryProduction]
	
	if stats.isDead == false:
		fillText += "Sickness: %s" % [sicknessInfo.GetNameString(stats.sickness)]
	else:
		fillText += "Dead"
		
	
	#displays text
	$HBoxContainer/VBoxContainer/Label.text = fillText
	
