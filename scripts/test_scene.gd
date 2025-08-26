extends Node2D

@onready var settlerPanel = $settlerPanel

@onready var settlerArray = [
	load("res://Resources/character_resources/test_settler.tres"),
	]

@export var settlerCard: PackedScene
@onready var sicknessInfo = load("res://Resources/sicknessInfo.tres") as SicknessInformation

@onready var roll = RandomNumberGenerator.new()

var settlerCardArray = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settlerPanel.hide()
	for settler in settlerArray:
		var settlerCardInstance = settlerCard.instantiate()
		$settlerPanel/HFlowContainer.add_child(settlerCardInstance)
		
		#loads character sheet based on resource in array
		var stats = settler
		settlerCardInstance.LoadStats(stats) as SettlerStats
		
		settlerCardArray.append(settlerCardInstance) 
	
	
	print(sicknessInfo.GetSurvivalChance(SicknessInformation.sickness.radStage2))


func _ProgressWeek():
	_RoleSicknesses()
	for settlerCard in settlerCardArray:
		settlerCard.FillCard()


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
				#currentSettler.sickness = SicknessInformation.sickness.notSick
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
