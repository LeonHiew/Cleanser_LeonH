extends Control

signal resources_updated(food: int, water: int, military: int, ingenuity: int, scraps: int, base_military: int, base_ingenuity: int)
signal closed
signal trades_updated(completed_trades)

@onready var resource_label = $Panel/ResourceLabel
@onready var trade_container = $tradePanel/TradeContainer
@onready var back_button = $BackButton

@onready var townSuppliesLabel = $BackgroundTVs/TownSuppliesTitleLabel/TownSuppliesLabel
@onready var miltaryLabel = $BackgroundTVs/TownPowerTitleLabel/MilitaryLabel
@onready var miltaryDetailsLabel = $BackgroundTVs/TownPowerTitleLabel/MilitaryLabel/MilitaryDetailsLabel
@onready var ingenuityLabel = $BackgroundTVs/TownPowerTitleLabel/IngenuityLabel
@onready var ingenuityDetailsLabel = $BackgroundTVs/TownPowerTitleLabel/IngenuityLabel/IngenuityDetailsLabel

@onready var roundLabel = $BackgroundTVs/RoundLabel
@onready var raidLabel = $BackgroundTVs/RaidLabel
@onready var raidMessageLabel = $weeklyLogPanel/weeklyLogPaperPanel/ScrollContainer/weeklyLogLabel
@onready var raidMessagePanel = $weeklyLogPanel

@export var trade_card_scene: PackedScene = preload("res://scenes/TradeCard.tscn")

#current resources
var current_food: int 
var current_water: int 
var current_military: int 
var current_ingenuity: int 
var current_scraps: int
var current_base_military: int 
var current_base_ingenuity: int 
var current_round_number: int

var raidWeeks = [2, 5, 10, 15]
var raidMilitaryRequirements = {
	#week : min military needed
	2: 15,
	5: 25,
	10: 40,
	15: 60
}

#var trade_offers: Array = []
#var roll = RandomNumberGenerator.new()

var trade_offers: Array = []
var completed_buy_trades: Dictionary = {}

func _ready():
	back_button.pressed.connect(_on_back_button_pressed)
	
	self.visible = true
	
	
func setup_resources(food: int, water: int, military: int, ingenuity: int, scraps: int, base_military: int, base_ingenuity: int, round_number: int, offers: Array, completed_trades: Dictionary):
	current_food = food
	current_water = water
	current_military = military
	current_ingenuity = ingenuity
	current_scraps = scraps
	current_base_military = base_military
	current_base_ingenuity = base_ingenuity
	current_round_number = round_number
	
	trade_offers = offers
	completed_buy_trades = completed_trades
	
	#_generate_trade_offers()
	_update_resource_display()
	_generate_trade_cards()
	

#func _generate_trade_offers():
	#trade_offers.clear()
	#var tradeResources = ["food", "water", "military", "ingenuity"]
	#
	#var num_trades = roll.randi_range(2,4)
	#for i in num_trades:
		#var scraps_cost = roll.randi_range(2,4)
		#var resource_amount = roll.randi_range(1,5)
		#var res_type = tradeResources.pick_random()
		#trade_offers.append({
			#"type": "buy",
			#"scraps_cost": scraps_cost,
			#"resource_type": res_type,
			#"resource_amount": resource_amount
		#})
		#
	#for res_type in tradeResources:
		#var resource_cost = roll.randi_range(1,3)
		#var scraps_amount = 1
		#trade_offers.append({
			#"type": "sell",
			#"resource_type": res_type,
			#"resource_cost": resource_cost,
			#"scraps_amount": scraps_amount
		#})

func _generate_trade_cards():
	#clear previous/ existing cards
	for child in trade_container.get_children():
		child.queue_free()
		
	#make new cards 
	for offer in trade_offers:
		var card = trade_card_scene.instantiate()
		trade_container.add_child(card)
		
		if offer["type"] == "buy":
			card.setup(offer["scraps_cost"], offer["resource_type"], offer["resource_amount"])
			if completed_buy_trades.has(offer["trade_id"]):
				card.mark_trade_completed()
			else:
				card.trade_accepted.connect(_on_buy_trade_accepted.bind(offer["trade_id"]))
		else:
			card.setup_sell_trade(offer["resource_type"], offer["resource_cost"], offer["scraps_amount"])
			card.sell_trade_accepted.connect(_on_sell_trade_accepted)
			

func _update_resource_display():
	#resource_label.text = "Current Resources:\nFood: %s\nWater: %s\nMilitary: %s\nIngenuity: %s\nScraps: %s" % [current_food, current_water, current_military, current_ingenuity, current_scraps]
	
	var resourceFillText = ""
	resourceFillText += "Food: %s \nWater: %s \nScraps: %s" %[
		current_food, current_water, current_scraps]
	townSuppliesLabel.text = resourceFillText
	

	miltaryLabel.text = "Miltary Power: %s "% [current_military]
	miltaryDetailsLabel.text = "Base Military: %s 
	Settler Military: %s" % [current_base_military, current_military - current_base_military]
	
	ingenuityLabel.text = "Ingenuity Power: %s "% [current_ingenuity]
	ingenuityDetailsLabel.text = "Base Ingenuity: %s
	Settler Ingenuity: %s" % [current_base_ingenuity, current_ingenuity - current_base_ingenuity]
	
	
	var nextRaidRound 
	for raidRound in raidWeeks:
		if raidRound <= current_round_number:
			continue
		if raidRound > current_round_number:
			nextRaidRound = raidRound - current_round_number
			break
	
	var roundFillText = "Round %s/15 \n
	Next Raid in %s Rounds" %[ current_round_number, nextRaidRound]
	roundLabel.text = roundFillText

func _on_buy_trade_accepted(scraps: int, resource_type: String, resource_amount: int, trade_id: String):
	if current_scraps < scraps:
		print("Not enough scraps for trade!")
		return
		
	current_scraps -= scraps
	match resource_type:
		"food":
			current_food += resource_amount
		"water":
			current_water += resource_amount
		"military":
			current_military += resource_amount
			current_base_military += resource_amount
		"ingenuity":
			current_ingenuity += resource_amount
			current_base_ingenuity += resource_amount
			
			
	completed_buy_trades[trade_id] = true
	
	for card in trade_container.get_children():
		if card is PanelContainer and not card.is_sell_trade:
			if not card.trade_completed:
				if card.scraps_cost == scraps and card.resource_type == resource_type and card.resource_amount == resource_amount:
					card.mark_trade_completed()
					break

	_update_resource_display()
	print("Trade completed: %d scraps for %d %s." % [scraps, resource_amount, resource_type])
	 

func _on_sell_trade_accepted(resource_type: String, resource_cost: int, scraps_amount: int):
	var has_enough = false 
	match resource_type:
		"food":
			has_enough = current_food >= resource_cost
		"water":
			has_enough = current_water >= resource_cost
		"military":
			has_enough = current_base_military >= resource_cost
		"ingenuity":
			has_enough = current_base_ingenuity >= resource_cost
			
	if not has_enough:
		print("Not enough %s to sell!" % resource_type)
		return
		
	
	#execute sell trade 
	match resource_type:
		"food":
			current_food -= resource_cost
		"water":
			current_water -= resource_cost
		"military":
			#take from both, since townMilitary is baseTown + settlers
			current_base_military -= resource_cost
			current_military -= resource_cost
		"ingenuity":
			current_base_ingenuity -= resource_cost
			current_ingenuity -= resource_cost
			
	current_scraps += scraps_amount
		
	_update_resource_display()
	print("Sell trade completed: %d %s for %d scraps." % [resource_cost, resource_type, scraps_amount])


func _on_back_button_pressed():
	resources_updated.emit(
		current_food,
		current_water,
		current_military,
		current_ingenuity,
		current_scraps,
		current_base_military,
		current_base_ingenuity
	)
	trades_updated.emit(completed_buy_trades)
	
	closed.emit()
