extends Panel

var eventInfo: EventInformation = null

@onready var eventTitle = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/TitleLabel
@onready var eventDesc = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/DescriptionLabel

@onready var resourceDisplayArray = [
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer2,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer3
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eventInfo = load("res://Resources/eventInfo.tres") as EventInformation

#loads an event into the card
func loadStats(event: Array):
	print(event)
	eventTitle.text = event[0]
	eventDesc.text = event[1]
	for resourceDisplay in resourceDisplayArray:
		resourceDisplay.hide()

	var i = 0
	for key in event[2]:
		var resourceTarget = resourceDisplayArray[i]
		var label = resourceTarget.get_node("Panel/Label")
		resourceTarget.show()
		var fillText = "Empty fillText"
		match key:
			"food":
				fillText = "food "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
			"water":
				fillText = "water "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
			"military":
				fillText = "military "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
			"ingenuity":
				fillText = "ingenuity "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
			"settler":
				#make sure to skip as this isn't supposed
				#to be displayed to player
				continue
				#should change the desciption to use a random settler name
				#set in actual scene for later use, pass here
			"radStage1":
				fillText = "%s to %s settlers have caught stage 1 radiation sickness" % [
					event[2][key][0],event[2][key][1]
				]
			"radstage2":
				fillText = "%s to %s settlers have caught stage 2 radiation sickness" % [
					event[2][key][0],event[2][key][1]
				]
				
			#default, shouldn't be called
			#if it does something misspelled in event information
			_:
				push_error("an event key wasn't called in event_card: " + key)
		label.text = fillText
		i += 1
