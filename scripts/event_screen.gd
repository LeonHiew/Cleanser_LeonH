extends Control

@onready var eventCards = [
$EventCard,
$EventCard2,
$EventCard3,
]
@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func playEvents(events: Array) -> void:
	show()
	var i = 0
	for event in events:
		eventCards[i].loadStats(event)
		i += 1
	anim.play("new_animation")



func _on_close_cards_button_pressed() -> void:
	hide()
