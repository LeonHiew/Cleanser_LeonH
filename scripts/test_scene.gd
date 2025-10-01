extends Node2D

@onready var settlerPanel = $CanvasLayer/Control/settlerPanel
@onready var weeklyLogPanel = $CanvasLayer/Control/weeklyLogPanel
@onready var resourceLabel = $CanvasLayer/Control/Panel/resources
@onready var weeklyLogLabel = $CanvasLayer/Control/weeklyLogPanel/weeklyLogPaperPanel/weeklyLogLabel

@onready var tradePanel = $CanvasLayer/Control/tradePanel
@onready var tradeCardContainer = $CanvasLayer/Control/tradePanel/TradeCardContainer
@export var tradeCardScene:PackedScene = preload("res://scenes/TradeCard.tscn")

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
var townFood = 15
var townWater = 15
var townMilitary = 0
var townIngenuity = 0
var townScraps = 5
#base values because the values are calcualted differently
var baseTownMiltary = 10
var baseTownIngenuity = 0

#number of heals player can do
var healNumber = 1

#number of rounds progressed
var roundNumber = 0

#rarity of events Common, Uncommon, Rare
var eventRarityChances = [60,30,10]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settlerPanel.hide()
	weeklyLogPanel.hide()
	for settler in settlerArray:
		var settlerCardInstance = settlerCard.instantiate()
		$CanvasLayer/Control/settlerPanel/HFlowContainer.add_child(settlerCardInstance)
		
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
	Food: %s Water: %s Miltary: %s Ingenuity: %s Scraps: %s
	week %s/15
	"""% [townFood, townWater, townMilitary, townIngenuity, townScraps, roundNumber ]
	
	
	resourceLabel.text = fillText


#progresses the round
func _ProgressWeek():
	_RoleSicknesses()
	_calculateResources()
	_rollEvents()

	for CurrentSettlerCard in settlerCardArray:
		CurrentSettlerCard.FillCard()
	healNumber = 1
	roundNumber += 1
	
	_UpdateResourcesDisplay()
	_calculateMood()
	
	_ShowTradeEvent()
	
	if roundNumber == 15:
		get_tree().change_scene_to_file("res://scenes/win_scene.tscn")
		
	if townFood < 0 or townWater < 0:
		get_tree().change_scene_to_file("res://scenes/lost_screen.tscn")
		
		
	var bIsAllDead = true
	for settler in settlerArray:
		if settler.bIsDead == false:
			bIsAllDead = false
			break
	if bIsAllDead:
		get_tree().change_scene_to_file("res://scenes/lost_screen.tscn")
		

#logic behind the events system
#calculates amount of events that occur, whether they are positive or negative
#and deals with applying the changes the event creates
func _rollEvents():
	roll.randomize()
	var amountOfEvents = roll.randi_range(1,3)
	var positiveEventChance = pow(townIngenuity * 0.25, 2)
	var bannedEvents = []
	var fillText : String = ""
	for event in amountOfEvents:
		roll.randomize()
		var eventRoll = roll.randf_range(0,100)
		var currentEvent : Array
		var isPickingEVent = true
		if eventRoll <= positiveEventChance:
			while isPickingEVent:
				roll.randomize()
				var eventRarity =  roll.randf_range(0,100)
				var rarityKey 
				if eventRarity <= eventRarityChances[0]:
					rarityKey = "Common"
				elif eventRarity <= eventRarityChances[1] + eventRarityChances[0]:
					rarityKey = "Uncommon"
				elif eventRarity <= eventRarityChances[2] + eventRarityChances[1] + eventRarityChances[0]:
					rarityKey = "Rare"
				
				currentEvent = eventInfo.positiveEventArray[rarityKey].pick_random()
				if currentEvent[0] in bannedEvents:
					continue
				else:
					bannedEvents.append(currentEvent[0])
					for ban in currentEvent[3]:
						bannedEvents.append(ban)
					isPickingEVent = false
		else:
			while isPickingEVent:
				roll.randomize()
				var eventRarity =  roll.randf_range(0,100)
				var rarityKey 
				if eventRarity <= eventRarityChances[0]:
					rarityKey = "Common"
				elif eventRarity <= eventRarityChances[1] + eventRarityChances[0]:
					rarityKey = "Uncommon"
				elif eventRarity <= eventRarityChances[2] + eventRarityChances[1] + eventRarityChances[0]:
					rarityKey = "Rare"
					
				currentEvent = eventInfo.negativeEventArray[rarityKey].pick_random()
				if currentEvent[0] in bannedEvents:
					continue
				else:
					bannedEvents.append(currentEvent[0])
					for ban in currentEvent[3]:
						bannedEvents.append(ban)
					isPickingEVent = false
		
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
					
					_rollSickness(SicknessInformation.sickness.radStage1,
					currentEvent[2][key][0], currentEvent[2][key][1])
					
				"radstage2":
					
					_rollSickness(SicknessInformation.sickness.radStage2,
					currentEvent[2][key][0], currentEvent[2][key][1])
				
				"Mood":
					for settler in settlerArray:
						if settler.bIsDead != true:
							#needs to be negative, negatives go towards great
							settler.settlerMood = settler.settlerMood - currentEvent[2][key]
						if settler.settlerMood < 0:
							settler.settlerMood = 0
						if settler.settlerMood > 4:
							settler.settlerMood = 4
				#default, shouldn't be called
				#if it does triggers something is misspelled in event information
				_:
					push_error("a key is wrong in event array, the key is : " + key)
					
		fillText += "\n"
	weeklyLogLabel.text = """ Weekly Log
	""" + fillText

#called in _rollEvents
#useds to roll which settlers get infected and how many
func _rollSickness(sickness: SicknessInformation.sickness, minInfected: int, maxInfected: int):
	roll.randomize()
	var infectedAmount = roll.randi_range(minInfected,maxInfected)

	
	for infected in infectedAmount:
		var BIsApplyingSickness = true
		var targetSettler : SettlerStats
		while BIsApplyingSickness:
			if settlerArray.all(_isSick):
				BIsApplyingSickness = false
			targetSettler = settlerArray.pick_random()
			if targetSettler.sickness != SicknessInformation.sickness.notSick:
				continue
			else:
				targetSettler.sickness = sickness
				if targetSettler.settlerMood != 4:
					targetSettler.settlerMood += 1
				BIsApplyingSickness = false
			

#used for _rollSickness all,
#returns false if settler is not sick and true if dead or sick
func _isSick(settler: SettlerStats):
	if settler.bIsDead == true:
		return true
	elif settler.sickness == SicknessInformation.sickness.notSick:
		return false
	else:
		return true

#gets all settlers and updates resouces based on each settlers resource 
#production, drain and mood
func _calculateResources():
	#reset to base values as value isn't added each round for military 
	#and ingenuity
	townMilitary = baseTownMiltary
	townIngenuity = baseTownIngenuity
	
	for settler in settlerArray:
		if settler.bIsDead == true:
			continue
		var moodBonus = 0.0
		match SettlerStats.settlerMoods.find_key(settler.settlerMood):
			"Great": moodBonus = 2 
			"Good": moodBonus = 1.5
			"Fine": moodBonus = 1
			"Bad": moodBonus = 0.7
			"Terrible": moodBonus = 0.5
			_: push_error("incorrect SettlerMood can't apply mood bonus %s" %[settler.settlerMood]) 
		
		townFood = townFood + round(settler.foodProduction * moodBonus) - settler.foodDrain
		townWater = townWater + round(settler.waterProduction * moodBonus) - settler.waterDrain
		townMilitary = townMilitary + round(settler.militaryProduction * moodBonus)
		townIngenuity = townIngenuity + round(settler.ingenuityProduction * moodBonus)


#checks all settlers for sicknesses
#if sick rolls if they live, die or get worse and updates resource
func _RoleSicknesses():
	for currentSettler in settlerArray:
		if currentSettler.bIsDead == true:
			continue
		if currentSettler.sickness != SicknessInformation.sickness.notSick:
			var survivalChance =sicknessInfo.GetSurvivalChance(currentSettler.sickness)
			var deathChance = sicknessInfo.GetDeathChance(currentSettler.sickness)
			var worsenChance = sicknessInfo.GetWorsenChance(currentSettler.sickness)
			
			#error check
			if (survivalChance + deathChance + worsenChance != 100):
				push_error(currentSettler.sickness + " hads odds that don't add up to 100")
			
			roll.randomize()	
			var sicknessRoll = roll.randf_range(0, 100)
			#survive
			if sicknessRoll <= survivalChance:
				currentSettler.sickness = SicknessInformation.sickness.notSick
				if currentSettler.settlerMood != 0:
					currentSettler.settlerMood -= 1
			#die
			elif sicknessRoll <= survivalChance + deathChance:
				currentSettler.bIsDead = true
				#you wouldn't feel great if you died
				currentSettler.settlerMood = SettlerStats.settlerMoods.Terrible
			#get worse
			elif  sicknessRoll <= survivalChance + deathChance + worsenChance:
				currentSettler.sickness = sicknessInfo.GetWorsenTarget(currentSettler.sickness)
				if currentSettler.settlerMood != 4:
					currentSettler.settlerMood += 1

#changes the mood of all settlers with the goal of bring them towards Fine
func _calculateMood():
	for currentSettler in settlerArray:
		if currentSettler.bIsDead:
			continue
		roll.randomize()
		var moodChangeChance = 30
		var moodChangeRoll = roll.randi_range(0, 100)
		if moodChangeRoll <= moodChangeChance:
			match SettlerStats.settlerMoods.find_key(currentSettler.settlerMood):
				"Great": currentSettler.settlerMood += 1
				"Good": currentSettler.settlerMood += 1
				"Fine": currentSettler.settlerMood += 0 # do nothing
				"Bad": currentSettler.settlerMood -= 1
				"Terrible": currentSettler.settlerMood -= 1 





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
		if stats.settlerMood != 0:
			stats.settlerMood = stats.settlerMoods.Great
		healNumber -= 1 
		print(stats.settlerName + " has been healed! Remaining heals: " + str(healNumber))
		
	#refresh cards 
	for card in settlerCardArray:
		card.FillCard()
	

func _ShowTradeEvent():
	tradePanel.show()
	#weeklyLogLabel.text += "\nA travelling merchant arrives this week offering trades!"
	if weeklyLogLabel:
		weeklyLogLabel.text += "\nA travelling merchant arrives this week offering trades!"
	else:
		push_error("weeklyLogLabel is null")
	
	#clear old trades from previous week
	for child in tradeCardContainer.get_children():
		child.queue_free()
		
	var tradeResources = ["food", "water", "military", "ingenuity"]
	
	#generate 2-4 trade cards 
	var num_trades = roll.randi_range(2,4)
	
	for i in num_trades:
		var scraps_cost = roll.randi_range(1,3)
		var resource_amount = roll.randi_range(1,3)
		var res_type = tradeResources.pick_random()
		
		var card = tradeCardScene.instantiate()
		card.setup(scraps_cost, res_type, resource_amount)
		card.trade_accepted.connect(_on_trade_accepted)
		tradeCardContainer.add_child(card)
		
		
func _on_trade_accepted(scraps:int, resource_type:String, resource_amount:int):
	if townScraps < scraps:
		print("Not enough scraps for trade!")
		return
		
	townScraps -= scraps
	match resource_type:
		"food":
			townFood += resource_amount
		"water":
			townWater += resource_amount
		"military":
			townMilitary += resource_amount
		"ingenuity":
			townIngenuity += resource_amount
			
	_UpdateResourcesDisplay()
	print("Trade completed: %d scraps for %d %s." % [scraps, resource_amount, resource_type])
	
