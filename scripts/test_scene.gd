extends Node2D

@onready var settlerPanel = $CanvasLayer/settlerPanel
@onready var weeklyLogPanel = $CanvasLayer/weeklyLogPanel
@onready var resourceLabel = $CanvasLayer/Panel/resources

@onready var settlerArray = [
	load("res://Resources/character_resources/AI_settler.tres"),
	load("res://Resources/character_resources/Baldroy_settler.tres"),
	load("res://Resources/character_resources/Caelan_settler.tres"),
	load("res://Resources/character_resources/Caitlyn_settler.tres"),
	load("res://Resources/character_resources/Emily_settler.tres"),
	load("res://Resources/character_resources/Jacob_settler.tres"),
	load("res://Resources/character_resources/Jessie_settler.tres"),
	load("res://Resources/character_resources/Johni_settler.tres")
	]

@export var settlerCard: PackedScene
@onready var sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation

@onready var roll = RandomNumberGenerator.new()

var settlerCardArray = []

#town resources
var townFood = 10
var townWater = 10
var townMilitary = 0
var townIngenuity = 0
#base values because the values are calcualted differently
var baseTownMiltary = 10
var baseTownIngenuity = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settlerPanel.hide()
	weeklyLogPanel.hide()
	for settler in settlerArray:
		var settlerCardInstance = settlerCard.instantiate()
		$CanvasLayer/settlerPanel/HFlowContainer.add_child(settlerCardInstance)
		
		#loads character sheet based on resource in array
		var stats = settler
		settlerCardInstance.LoadStats(stats) as SettlerStats
		
		settlerCardArray.append(settlerCardInstance) 
		
		townMilitary = townMilitary + stats.militaryProduction
		townIngenuity = townIngenuity + stats.ingenuityProduction
	
	townMilitary += baseTownMiltary
	townIngenuity += baseTownIngenuity
	_UpdateResourcesDisplay()
	
#updates resourcelabel display to current values
func _UpdateResourcesDisplay():
	var fillText = """Town Resources
	Food: %s Water: %s Miltary: %s Ingenuity: %s
	"""% [townFood, townWater, townMilitary, townIngenuity]
	
	resourceLabel.text = fillText


#progresses the round
func _ProgressWeek():
	_RoleSicknesses()
	_calculateResources()
	for settlerCard in settlerCardArray:
		settlerCard.FillCard()

#gets all settlers and updates resouces based on each settlers resource 
#production and drain
func _calculateResources():
	townMilitary = baseTownMiltary
	townIngenuity = baseTownIngenuity
	for settler in settlerArray:
		var currentSettler = settler
		if currentSettler.isDead == true:
			continue
		townFood = townFood + currentSettler.foodProduction - currentSettler.foodDrain
		townWater = townWater + currentSettler.waterProduction - currentSettler.waterDrain
		townMilitary = townMilitary + currentSettler.militaryProduction
		townIngenuity = townIngenuity + currentSettler.ingenuityProduction
	_UpdateResourcesDisplay()

#checks all settlers for sicknesses
#if sick rolls if they live, die or get worse and updates resource
func _RoleSicknesses():
	for settler in settlerArray:
		var currentSettler = settler
		if currentSettler.isDead == true:
			continue
		if currentSettler.sickness != SicknessInformation.sickness.notSick:
			var survivalChance =sicknessInfo.GetSurvivalChance(currentSettler.sickness)
			var deathChance = sicknessInfo.GetDeathChance(currentSettler.sickness)
			var worsenChance = sicknessInfo.GetWorsenChance(currentSettler.sickness)
			
			#error check
			if (survivalChance + deathChance + worsenChance != 100):
				print(currentSettler.sickness + " hads odds that don't add up to 100")
			
			roll.randomize()
			var sicknessRoll = roll.randf_range(0, 100)
			
			if sicknessRoll <= survivalChance:
				currentSettler.sickness = SicknessInformation.sickness.notSick
				print("survived")
			elif sicknessRoll <= survivalChance + deathChance:
				currentSettler.isDead = true
				print("died")
			elif  sicknessRoll <= survivalChance + deathChance + worsenChance:
				currentSettler.sickness = sicknessInfo.GetWorsenTarget(currentSettler.sickness)
				print("worsen")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_settler_log_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		settlerPanel.show()
	else:
		settlerPanel.hide()


func _on_progress_button_pressed() -> void:
	_ProgressWeek()


func _on_weekly_log_button_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		weeklyLogPanel.show()
		print("show")
	else:
		weeklyLogPanel.hide()
		print("hide")
