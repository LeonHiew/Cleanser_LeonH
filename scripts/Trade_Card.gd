extends PanelContainer

signal trade_accepted(scraps:int, resource_type:String, resource_amount:int)

var scraps_cost : int 
var resource_type : String 
var resource_amount : int 

@onready var desc_label = $VBoxContainer/Label
@onready var desc_button = $VBoxContainer/Label/ButtonTra

func setup(scraps:int, res_type:String, res_amount:int):
	scraps_cost = scraps
	resource_type = res_type
	resource_amount = res_amount
	desc_label.text = "Trade %d scraps for %d %s" %[scraps, res_amount, res_type]
	

func _on_tradeButton_pressed() -> void:
	emit_signal("trade_accepted", scraps_cost, resource_type, resource_amount)
