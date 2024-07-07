extends CanvasLayer
class_name GameOverUI
@onready var timeLabel: Label = %timeSurvived
@onready var monstersLabel: Label = %monstersDefeated

@export var restartDelay:float = 5
var restartCooldown: float 

func _ready():
	timeLabel.text = GameManager.timeElapsedString
	monstersLabel.text = str(GameManager.monstersDefeatedCounter)
	restartCooldown = restartDelay
func _process(delta):
	restartCooldown -= delta

		
func restartGame():
	GameManager.reset()
	get_tree().reload_current_scene()
	
	pass
	


func _on_button_pressed():
	
	restartGame()
	pass # Replace with function body.

