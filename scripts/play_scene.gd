extends Node2D

@onready var eventInfo = load("res://Resources/eventInfo.tres") as EventInformation

@onready var roll = RandomNumberGenerator.new()

@onready var eventCard = $EventCard

#rarity of events Common, Uncommon, Rare
var eventRarityChances = [60,30,10]

var townIngenuity = 25
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _ProgressWeek():
	
	
	_rollEvents()


#logic behind the events system
#calculates amount of events that occur, whether they are positive or negative
#and deals with applying the changes the event creates
func _rollEvents():
	roll.randomize()
	var amountOfEvents = 1
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
					pass
					#townFood += currentEvent[2][key]
				"water":
					pass
					#townWater += currentEvent[2][key]
				"military":
					pass
					#baseTownMiltary += currentEvent[2][key]
				"ingenuity":
					pass
					#baseTownIngenuity += currentEvent[2][key]
				"settler":
					pass
					#var target = settlerArray.pick_random()
					#fillText = fillText.replace("settler.name",target.settlerName)
				"radStage1":
					
					_rollSickness(SicknessInformation.sickness.radStage1,
					currentEvent[2][key][0], currentEvent[2][key][1])
					
				"radstage2":
					
					_rollSickness(SicknessInformation.sickness.radStage2,
					currentEvent[2][key][0], currentEvent[2][key][1])
				#default, shouldn't be called
				#if it does something misspelled in event information
				_:
					push_error("a key is wrong in event array, the key is : " + key)
					
		fillText += "\n"
		print("fillcard")
		eventCard.loadStats(currentEvent)
		
	#weeklyLogLabel.text = """ Weekly Log
	#""" + fillText

func _rollSickness(sickness: SicknessInformation.sickness, minInfected: int, maxInfected: int):
		pass
func _on_progress_button_pressed() -> void:
	_ProgressWeek()
