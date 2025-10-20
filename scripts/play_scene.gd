extends Node2D

@onready var eventInfo = load("res://Resources/eventInfo.tres") as EventInformation

@onready var roll = RandomNumberGenerator.new()

@onready var eventScreen = $CanvasLayer/EventScreen

@onready var weeklyLogPanel = $weeklyLogPanel
@onready var townSuppliesLabel = $BackgroundTVs/TownSuppliesTitleLabel/TownSuppliesLabel

@onready var miltaryLabel = $BackgroundTVs/TownPowerTitleLabel/MilitaryLabel
@onready var miltaryDetailsLabel = $BackgroundTVs/TownPowerTitleLabel/MilitaryLabel/MilitaryDetailsLabel
@onready var ingenuityLabel = $BackgroundTVs/TownPowerTitleLabel/IngenuityLabel
@onready var ingenuityDetailsLabel = $BackgroundTVs/TownPowerTitleLabel/IngenuityLabel/IngenuityDetailsLabel

#@onready var roundLabel = $CanvasLayer/Control/Panel/RoundDisplay
@onready var roundLabel = $BackgroundTVs/RoundLabel
@onready var raidLabel = $BackgroundTVs/RaidLabel
@onready var raidMessageLabel = $weeklyLogPanel/weeklyLogPaperPanel/ScrollContainer/weeklyLogLabel
@onready var raidMessagePanel = $weeklyLogPanel


#trade system variables 
@onready var tradeButton = $TradeButton
@export var tradeScreenScene: PackedScene = preload("res://scenes/trade_screen.tscn")
var tradeScreenInstance: Node = null

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

@onready var screenArray = [
	$SettlerTVs/Jacob,
	$SettlerTVs/Johni,
	$SettlerTVs/Baldroy,
	$SettlerTVs/AI,
	$SettlerTVs/Luffy,
	$SettlerTVs/Caelan,
	$SettlerTVs/Caitlyn,
	$SettlerTVs/Jessie
]

@onready var sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation
@onready var settlerBook = $SettlerBook


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

#trade event var 
var tradeEventChance = 30
var baseTradeEventChance = 30
var currentWeekHasTrade = false
var tradeChanceIncrease = 15
var currentTradeOffers = []
var completedBuyTrades = {}

#raid event variables 
var raidWeeks = [2, 5, 10, 15]
var raidMilitaryRequirements = {
	#week : min military needed
	2: 15,
	5: 25,
	10: 40,
	15: 60
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weeklyLogPanel.hide()
	eventScreen.hide()
	tradeButton.hide()
	
	
	for settler in settlerArray:
		#loads character sheet based on resource in array
		var stats = settler
		
		townMilitary = townMilitary + stats.militaryProduction
		townIngenuity = townIngenuity + stats.ingenuityProduction
		
	#heal signal
	settlerBook.heal_request.connect(_on_heal_request)
	townMilitary += baseTownMiltary
	townIngenuity += baseTownIngenuity
	_UpdateResourcesDisplay()
	
	tradeButton.pressed.connect(_openTradeScreen)
	
#updates resourcelabel display to current values
func _UpdateResourcesDisplay():
	var resourceFillText = ""
	resourceFillText += "Food: %s \nWater: %s \nScraps: %s" %[
		townFood, townWater, townScraps]
	townSuppliesLabel.text = resourceFillText
	

	miltaryLabel.text = "Miltary Power: %s "% [townMilitary]
	miltaryDetailsLabel.text = "Base Military: %s 
	Settler Military: %s" % [baseTownMiltary, townMilitary - baseTownMiltary]
	
	ingenuityLabel.text = "Ingenuity Power: %s "% [townIngenuity]
	ingenuityDetailsLabel.text = "Base Ingenuity: %s
	Settler Ingenuity: %s" % [baseTownIngenuity, townIngenuity - baseTownIngenuity]
	
	
	var nextRaidRound 
	for raidRound in raidWeeks:
		if raidRound <= roundNumber:
			continue
		if raidRound > roundNumber:
			nextRaidRound = raidRound - roundNumber
			break
	
	var roundFillText = "Round %s/15 \n
	Next Raid in %s Rounds" %[ roundNumber, nextRaidRound]
	roundLabel.text = roundFillText


#progresses the round
func _ProgressWeek():
	raidLabel.text = ""
	_RoleSicknesses()
	_calculateResources()
	_rollEvents()

	
	healNumber = 1
	roundNumber += 1
	
	_UpdateResourcesDisplay()
	_calculateMood()
	
	_CheckForTradeEvent()
	
	_CheckForRaidEvent()
	
	if roundNumber == 16:
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
	
	#refresh cards after all calculations are done
	for CurrentSettlerScreen in screenArray:
			CurrentSettlerScreen.update()

#logic behind the events system
#calculates amount of events that occur, whether they are positive or negative
#and deals with applying the changes the event creates
func _rollEvents():
	roll.randomize()
	var eventArray = []
	var amountOfEvents = 3
	var positiveEventChance = pow(townIngenuity * 0.03 - 4.5, 3) + 100
	var bannedEvents = []
	for event in amountOfEvents:
		var settler_target = ""
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
					var target =  settlerArray.pick_random()
					settler_target =  target.settlerName
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
					
		eventArray.append(currentEvent)
	eventScreen.playEvents(eventArray)

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
			"Great": moodBonus = 1.5 
			"Good": moodBonus = 1.3
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
		if stats.settlerMood != stats.settlerMoods.Great:
			stats.settlerMood = stats.settlerMoods.Great
		healNumber -= 1 
		print(stats.settlerName + " has been healed! Remaining heals: " + str(healNumber))
		
	#refresh cards 
	for screen in screenArray:
		screen.update()
	
	


#Trade system code 

func _updateTradeButton():
	if currentWeekHasTrade:
		tradeButton.show()
	else:
		tradeButton.hide()

func _CheckForTradeEvent():
	roll.randomize()
	var tradeRoll = roll.randi_range(1, 100)
	currentWeekHasTrade = false
	print("Trade event check - Chance: " + str(tradeEventChance) + "%, Roll: " + str(tradeRoll))
	
	if tradeRoll <= tradeEventChance:
		currentWeekHasTrade = true
		_generateWeeklyTradeOffers()
		tradeEventChance = baseTradeEventChance
		print("Trade event occurred this week!")
	else:
		tradeEventChance = min(tradeEventChance + tradeChanceIncrease, 90)
		print("No trade event this week!")
		
	_updateTradeButton()

func _generateWeeklyTradeOffers():
	currentTradeOffers.clear()
	completedBuyTrades.clear()
	
	var tradeResources = ["food", "water", "military", "ingenuity"]
	
	var num_trades = roll.randi_range(2,4)
	for i in num_trades:
		var scraps_cost = roll.randi_range(2,4)
		var resource_amount = roll.randi_range(1,5)
		var res_type = tradeResources.pick_random()
		
		var trade_id = "buy_%s_%d_%d" % [res_type, scraps_cost, resource_amount]
		
		currentTradeOffers.append({
			"type": "buy",
			"scraps_cost": scraps_cost,
			"resource_type": res_type,
			"resource_amount": resource_amount,
			"trade_id": trade_id
		})
		
	for res_type in tradeResources:
		var resource_cost = roll.randi_range(2,4)
		var scraps_amount = 1
		currentTradeOffers.append({
			"type": "sell",
			"resource_type": res_type,
			"resource_cost": resource_cost,
			"scraps_amount": scraps_amount,
		})



func _openTradeScreen():
	if tradeScreenScene == null:
		push_error("Trade screen scene could not load")
		return 
		
	if tradeScreenInstance != null:
		return
	
	_hidePlaySceneUI()
	
	tradeScreenInstance = tradeScreenScene.instantiate()
	add_child(tradeScreenInstance)
	
	tradeScreenInstance.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	tradeScreenInstance.setup_resources(
		townFood,
		townWater,
		townMilitary,
		townIngenuity,
		townScraps,
		baseTownMiltary,
		baseTownIngenuity,
		roundNumber,
		currentTradeOffers, 
		completedBuyTrades
	)
	
	tradeScreenInstance.resources_updated.connect(_on_trade_resources_updated)
	tradeScreenInstance.closed.connect(_on_trade_screen_closed)
	tradeScreenInstance.trades_updated.connect(_on_trades_updated)

func _on_trades_updated(updated_completed_trades):
	completedBuyTrades = updated_completed_trades



func _on_trade_screen_closed():
	if tradeScreenInstance:
		tradeScreenInstance.queue_free()
		tradeScreenInstance = null
		
	_showPlaySceneUI()

func _on_trade_resources_updated(updated_food: int, updated_water: int, updated_military: int, updated_ingenuity: int, updated_scraps: int, updated_base_military: int, updated_base_ingenuity: int):
	#to update all resources from trade scene into main scene 
	townFood = updated_food
	townWater = updated_water
	townMilitary = updated_military
	townIngenuity = updated_ingenuity
	townScraps = updated_scraps
	baseTownMiltary = updated_base_military
	baseTownIngenuity = updated_base_ingenuity
	
	_UpdateResourcesDisplay()
	
	

func _hidePlaySceneUI():
	$BackgroundTVs.visible = false
	$SettlerTVs.visible = false
	$TradeButton.visible = false
	$ProgressButton2.visible = false
	
	if weeklyLogPanel:
		weeklyLogPanel.visible = false
	if eventScreen:
		eventScreen.visible = false
	if settlerBook:
		settlerBook.visible = false
	

func _showPlaySceneUI():
	$BackgroundTVs.visible = true
	$SettlerTVs.visible = true
	$ProgressButton2.visible = true
	
	_updateTradeButton()
	



func _CheckForRaidEvent():
	if roundNumber in raidWeeks:
		_HandleRaidEvent()

func _HandleRaidEvent():
	var requiredMilitary = raidMilitaryRequirements[roundNumber]
	var raidSuccess = townMilitary >= requiredMilitary
	
	var raidText = "\nRAID EVENT! Week " + str(roundNumber) + "!\n"
	raidText += "Raiders attack with strength: " + str(requiredMilitary) + "\n"
	raidText += "Your military strength: " + str(townMilitary) + "\n"
	
	if raidSuccess:
		raidText += "SUCCESS! You managed to defend against the raiders!\n"
		
		#reward for defending 
		var spoils = 2 * round(requiredMilitary * 0.2)
		townFood += spoils
		townWater += spoils
		townScraps += round(spoils / 2)
		raidText += "You salvaged " + str(spoils) + " food, water and " + str(round(spoils / 2)) + " scraps from the defeated raiders!\n"
		
	else:
		raidText += "FAILURE! The raiders overwhelemed your defenses!\n"
		
		#resources lost, 30% of water and food, 20% of scraps 
		var foodLost = round(townFood * 0.3)
		var waterLost = round(townWater * 0.3)
		var scrapsLost = round(townScraps * 0.2)
		
		townFood -= foodLost
		townWater -= waterLost
		townScraps -= scrapsLost
		
		raidText += "The raiders plundered: " + str(foodLost) + " food, " + str(waterLost) + " water, and " + str(scrapsLost) + " scraps.\n"
		
		#roll for character death, only 1 person dies but chances of dying are high 
		roll.randomize()
		var deathChance = 75
		var deathRoll = roll.randf_range(1, 100)
		
		if deathRoll <= deathChance:
			var livingSettlers = []
			for settler in settlerArray:
				if not settler.bIsDead:
					livingSettlers.append(settler)
					
			if livingSettlers.size() > 0:
				var victim = livingSettlers.pick_random()
				victim.bIsDead = true
				raidText += "Tragically, " + victim.settlerName + " was killed in the raid.\n"
			else:
				raidText += "All settlers are dead :("
				
		else:
			raidText += "Fortunately, no settlers were killed in the raid.\n"
			
	# Add raid text to log book
	if raidMessageLabel:
		raidMessageLabel.text = raidText
		raidMessagePanel.show()
	print("Raid Event - Week " + str(roundNumber) + ": " + ("Success" if raidSuccess else "Failure"))
	_UpdateResourcesDisplay()
	for screen in screenArray:
		screen.update()


func _on_raid_label_button_pressed() -> void:
	raidMessagePanel.hide()
