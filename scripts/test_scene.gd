extends Node2D

@onready var settlerPanel = $CanvasLayer/settlerPanel
@onready var weeklyLogPanel = $CanvasLayer/weeklyLogPanel
@onready var resourceLabel = $CanvasLayer/Panel/resources
@onready var weeklyLogLabel = $CanvasLayer/weeklyLogPanel/weeklyLogPaperPanel/weeklyLogLabel

@onready var settlerArray = [
	load("res://Resources/character_resources/AI_settler.tres"),
	load("res://Resources/character_resources/Baldroy_settler.tres"),
	load("res://Resources/character_resources/Caelan_settler.tres"),
	load("res://Resources/character_resources/Caitlyn_settler.tres"),
	load("res://Resources/character_resources/Luffy_settler.tres"),
	load("res://Resources/character_resources/Jacob_settler.tres"),
	load("res://Resources/character_resources/Jessie_settler.tres"),
	load("res://Resources/character_resources/Johni_settler.tres")
	]

@export var settlerCard: PackedScene
@onready var sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation
@onready var eventInfo = load("res://Resources/eventInfo.tres") as EventInformation

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

#number of heals player can do
var healNumber = 1

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
		
		#heal signal
		settlerCardInstance.heal_request.connect(_on_heal_request)
	
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
	_rollEvents()
	_UpdateResourcesDisplay()
	for settlerCard in settlerCardArray:
		settlerCard.FillCard()
	healNumber = 1

#logic behind the events system
#calculates amount of events that occur, whether they are positive or negative
#and deals with applying the changes the event creates
func _rollEvents():
	roll.randomize()
	var amountOfEvents = roll.randi_range(1,3)
	var positiveEventChance = pow(townIngenuity * 0.3, 2)
	var bannedEvents = []
	var fillText : String
	for event in amountOfEvents:
		roll.randomize()
		var eventRoll = roll.randf_range(0,100)
		var currentEvent : Array
		var pickingEvent = true
		if eventRoll <= positiveEventChance:
			while pickingEvent == true:
				currentEvent = eventInfo.positiveEventArray.pick_random()
				if currentEvent[0] in bannedEvents:
					continue
				else:
					bannedEvents.append(currentEvent[0])
					for ban in currentEvent[3]:
						bannedEvents.append(ban)
					pickingEvent = false
		else:
			while pickingEvent == true:
				currentEvent = eventInfo.negativeEventArray.pick_random()
				if currentEvent[0] in bannedEvents:
					continue
				else:
					bannedEvents.append(currentEvent[0])
					for ban in currentEvent[3]:
						bannedEvents.append(ban)
					pickingEvent = false
			
		fillText += currentEvent[0] + "\n" + currentEvent[1] + "\n"
		for key in currentEvent[2]:
			match key:
				"food":
					townFood += currentEvent[2][key]
				"water":
					townWater += currentEvent[2][key]
				"military":
					baseTownMiltary += currentEvent[2][key]
				"ingenuity":
					baseTownIngenuity += currentEvent[2][key]
				"settler":
					var target = settlerArray.pick_random()
					fillText = fillText.replace("settler.name",target.settlerName)
				"radStage1":
					roll.randomize()
					var infectedAmount = roll.randi_range(
						currentEvent[2][key][0], currentEvent[2][key][1])
					for infected in infectedAmount:
						var targetSettler : SettlerStats
						while true:
							targetSettler = settlerArray.pick_random()
							if targetSettler.sickness != SicknessInformation.sickness.notSick:
								continue
							else:
								targetSettler.sickness = SicknessInformation.sickness.radStage1
								break
						
		fillText += "\n"
	weeklyLogLabel.text = """ Weekly Log
	""" + fillText



#gets all settlers and updates resouces based on each settlers resource 
#production and drain
func _calculateResources():
	townMilitary = baseTownMiltary
	townIngenuity = baseTownIngenuity
	for settler in settlerArray:
		var currentSettler = settler
		if currentSettler.bIsDead == true:
			continue
		townFood = townFood + currentSettler.foodProduction - currentSettler.foodDrain
		townWater = townWater + currentSettler.waterProduction - currentSettler.waterDrain
		townMilitary = townMilitary + currentSettler.militaryProduction
		townIngenuity = townIngenuity + currentSettler.ingenuityProduction


#checks all settlers for sicknesses
#if sick rolls if they live, die or get worse and updates resource
func _RoleSicknesses():
	for settler in settlerArray:
		var currentSettler = settler
		if currentSettler.bIsDead == true:
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
				currentSettler.bIsDead = true
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

func _on_heal_request(stats: SettlerStats) -> void:
	if healNumber <= 0:
		print("No more heals left this week!")
	elif stats.bIsDead:
		print(stats.settlerName + " is dead and cannot be healed.")
		return
	elif stats.sickness == SicknessInformation.sickness.notSick:
		print(stats.settlerName + " is not sick.")
		return
	else:
		stats.sickness = SicknessInformation.sickness.notSick
		healNumber -= 1 
		print(stats.settlerName + " has been healed! Remaining heals: " + str(healNumber))
		
	#refresh cards 
	for card in settlerCardArray:
		card.FillCard()
	

	
