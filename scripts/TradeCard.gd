extends PanelContainer

signal trade_accepted(scraps:int, resource_type:String, resource_amount:int)
signal sell_trade_accepted(resource_type:String, resource_cost:int, scraps_amount:int)

var scraps_cost : int 
var resource_type : String 
var resource_amount : int 
var resource_cost : int
var scraps_amount : int 
var trade_completed : bool = false 
var is_sell_trade : bool = false

#@onready var desc_label = $VBoxContainer/Label
#@onready var trade_button = $VBoxContainer/Button

func setup(scraps:int, res_type:String, res_amount:int):
	scraps_cost = scraps
	resource_type = res_type
	resource_amount = res_amount
	is_sell_trade = false
	
		
	var desc_label = $VBoxContainer/Label
	var trade_button = $VBoxContainer/Button
	
	var filltext = ""
	
	filltext += "Trade %d scraps for %d %s" % [scraps, res_amount, res_type]
	
	desc_label.text = filltext
	
	if trade_button:
		trade_button.text = "Buy"
	
		

func setup_sell_trade(res_type:String, res_cost:int, scraps_amt:int):
	resource_type = res_type
	resource_cost = res_cost
	scraps_amount = scraps_amt
	is_sell_trade = true
	
	var desc_label = $VBoxContainer/Label
	var trade_button = $VBoxContainer/Button
	
	var filltext = ""
	
	filltext += "Sell %d %s for %d scraps" % [res_cost, _get_resource_name(res_type), scraps_amt]
	
	desc_label.text = filltext
	
	if trade_button:
		trade_button.text = "Sell"


func _on_tradeButton_pressed() -> void:
	if not trade_completed:
		if is_sell_trade:
			emit_signal("sell_trade_accepted", resource_type, resource_cost, scraps_amount)
		else:
			emit_signal("trade_accepted", scraps_cost, resource_type, resource_amount)
		
		
		
func mark_trade_completed():
	if not trade_completed:
		trade_completed = true 
		
		var desc_label = $VBoxContainer/Label
		var trade_button = $VBoxContainer/Button
		
		#update trade to completed 
		var complete_text = "TRADE COMPLETED\n"
		desc_label.text = complete_text
		
		#disable trade button after trade complete 
		if trade_button:
			trade_button.disabled = true
			trade_button.text = "Done"
			trade_button.modulate = Color.DIM_GRAY
	
# Helper function to get proper resource name
func _get_resource_name(res_type: String) -> String:
	match res_type:
		"food":
			return "Food"
		"water":
			return "Water"
		"military":
			return "Military"
		"ingenuity":
			return "Ingenuity"
		_:
			return res_type
