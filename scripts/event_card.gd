extends Panel

var eventInfo: EventInformation = null

@onready var seperator = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/HSeparator

@onready var edgePanel = $"."
@onready var eventForGround = $VBoxContainer/eventForground
@onready var RarityLabel = $RarityLabel
@onready var eventTitle = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/TitleLabel
@onready var eventDesc = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/DescriptionLabel
@onready var resourceDisplayPanelArray = [
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer/Panel,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer2/Panel,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer3/Panel
]

@onready var resourceDisplayArray = [
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer2,
	$VBoxContainer/eventForground/HBoxContainer/VBoxContainer/ResourceContainer3
]

@onready var eventIcon = $VBoxContainer/eventForground/HBoxContainer/VBoxContainer/PanelContainer/VBoxContainer/HBoxContainer/Control/eventIcon

#resource icons
@onready var foodImage = preload("res://assets/img/final art/resize/Food.png")
@onready var waterImage = preload("res://assets/img/final art/resize/Water.png")
@onready var goldImage = preload("res://assets/img/final art/resize/Gold.png")
@onready var militaryImage = preload("res://assets/img/final art/resize/Military.png")
@onready var ingenuityImage = preload("res://assets/img/final art/resize/Ingenuity_.png")

#card images
@onready var goodEventImage = preload("res://assets/img/final art/resize/Good ev.png")
@onready var badEventImage = preload("res://assets/img/final art/resize/Bad event.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eventInfo = load("res://Resources/eventInfo.tres") as EventInformation


#loads an event into the card
func loadStats(eventArray: Array):
	_changeLooks(eventArray[0], eventArray[1])
	var event = eventArray[2]
	eventTitle.text = event[0]
	eventDesc.text = event[1]
	for resourceDisplay in resourceDisplayArray:
		resourceDisplay.hide()

	var i = 0
	for key in event[2]:
		var resourceTarget = resourceDisplayArray[i]
		var label = resourceTarget.get_node("Panel/Label")
		var icon = resourceTarget.get_node("Control/Icon")
		resourceTarget.show()
		var fillText = "Empty fillText"
		match key:
			"food":
				fillText = "food "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
				icon.texture = foodImage
			"water":
				fillText = "water "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
				icon.texture = waterImage
			"military":
				fillText = "military "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
				icon.texture = militaryImage
			"ingenuity":
				fillText = "ingenuity "
				if event[2][key] > 0:
					fillText += "+%s" %[event[2][key]]
				else:
					fillText += "%s" %[event[2][key]]
				icon.texture = ingenuityImage
			"settler":
				#eventDesc.text = eventDesc.text.replace("settler.name", settlerTarget)
				continue
				#should change the desciption to use a random settler name
				#set in actual scene for later use, pass here
			"radStage1":
				fillText = "%s to %s settlers have caught moderate radiation sickness" % [
					event[2][key][0],event[2][key][1]
				]
			"radStage2":
				fillText = "%s to %s settlers have caught severe radiation sickness" % [
					event[2][key][0],event[2][key][1]
				]
			"Mood":
				if event[2][key] < 0:
					fillText = "all settlers have a worse mood"
				if event[2][key] > 0:
					fillText = "all settlers have a better mood"
			#default, shouldn't be called
			#if it does something misspelled in event information
			_:
				push_error("an event key wasn't called in event_card: " + key)
		label.text = fillText
		i += 1


# change cards look based on whether or not its positive or negative
func _changeLooks(eventType: String, eventRarity: String):
	if eventType == "positive":
		edgePanel.self_modulate = Color(0.784, 0.89, 0.949, 1.0)
		for resourcePanel in resourceDisplayPanelArray:
			resourcePanel.self_modulate = Color(0.937, 0.98, 1.0, 1.0)
		eventTitle.self_modulate = Color(0.337, 0.69, 0.894, 1.0)
		eventDesc.self_modulate = Color(0.129, 0.153, 0.459, 1.0)
		seperator.self_modulate = Color(0.129, 0.153, 0.459, 1.0)
		
		eventIcon.texture = goodEventImage
	if eventType == "negative":
		edgePanel.self_modulate = Color(0.937, 0.694, 0.718, 1.0)
		for resourcePanel in resourceDisplayPanelArray:
			resourcePanel.self_modulate = Color(0.996, 0.863, 0.867, 1.0)
		eventTitle.self_modulate = Color(0.976, 0.051, 0.133, 1.0)
		eventDesc.self_modulate = Color(0.502, 0.047, 0.098, 1.0)
		seperator.self_modulate = Color(0.502, 0.047, 0.098, 1.0)
		
		eventIcon.texture = badEventImage
	
	RarityLabel.text = eventRarity
