extends Control

#inbuilt function that grabs inputs
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if get_tree().paused == false:
			$".".show()
			get_tree().paused = true
		elif get_tree().paused == true:
			$".".hide()
			get_tree().paused = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()


func _on_continue_button_pressed() -> void:
	$".".hide()
	get_tree().paused = false


func _on_quit_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_desktop_button_pressed() -> void:
	get_tree().quit()
