extends CanvasLayer

@onready var timerLabel: Label = %timerLabel
@onready var meatLabel: Label = %meatLabel
@onready var moneyLabel: Label = %moneyLabel

func _process(delta:float):
	timerLabel.text = GameManager.timeElapsedString
	
	meatLabel.text = str(GameManager.meatCounter)
	moneyLabel.text = str(GameManager.moneyCounter)



