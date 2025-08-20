extends Panel

var stats: SettlerStats = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HBoxContainer/VBoxContainer/Sprite2D.texture = stats.settlerPortrait


func LoadStats(settlerStats: SettlerStats) -> void:
	stats = settlerStats
