extends Control
class_name titleScreen

func _ready():
	$Panel/VBoxContainer/start.grab_focus()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	
	
func _on_options_pressed():
	get_tree().change_scene_to_file("res://options.tscn")
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()




func _on_check_button_pressed():
	pass # Replace with function body.
