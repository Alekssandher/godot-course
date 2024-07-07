extends Control



func _process(delta):
	if Input.is_action_just_pressed("pause"):
		GameManager.a *= -1
		
		
	elif GameManager.a == -1:
		hide()
		get_tree().paused = false
		%pause.visible = true
		
	elif GameManager.a == 1:
		show()
		get_tree().paused = true
		%pause.visible = false
	
	


func _on_button_pressed():
	GameManager.a *= -1
	hide()
	get_tree().paused = false


func _on_pause_pressed():
	GameManager.a *= -1
	show()
	get_tree().paused = true
