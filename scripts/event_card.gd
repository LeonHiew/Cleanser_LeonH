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
		resourceTarget.show()
		match key:
			"food":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added food"
			"water":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added water"
			"military":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added military"
			"ingenuity":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added ingenuity"
			"settler":
				pass
				#should change the desciption to use a random settler name
				#set in actual scene for later use, pass here
			"radStage1":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added radStage1"
			"radstage2":
				var label = resourceTarget.get_node("Panel/HBoxContainer/Label")
				label.text ="added radStage2"
			#default, shouldn't be called
			#if it does something misspelled in event information
			_:
				push_error("an event key wasn't called in event_card: " + key)
		i += 1
