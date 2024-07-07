extends Node

signal gameOver

var timeElapsed: float = 0
var meatCounter: int = 0
var moneyCounter: int = 0
var timeElapsedString: String 

var monstersDefeatedCounter: int = 0 
var player: Player
var playerPosition: Vector2
var isGameOver: bool = false

#Pause
var a = -1

func _process(delta):

	timeElapsed += delta
	var timeElapsedSecs: int = floori(timeElapsed)
	var seconds: int = timeElapsedSecs % 60
	var minutes: int = timeElapsedSecs / 60
	var hours: int = minutes / 60
	
	if hours >= 1:
		timeElapsedString = "%02d:%02d:%02d" % [hours, minutes, seconds]
	else:
		timeElapsedString = "%02d:%02d" % [minutes, seconds]
		
func endGame():
	if isGameOver: return
	isGameOver = true
	gameOver.emit()
	
func reset():
	player = null
	playerPosition = Vector2.ZERO
	isGameOver = false 
	
	timeElapsed = 0
	meatCounter = 0
	
	timeElapsedString = "00:00"


	for connection in gameOver.get_connections():
		gameOver.disconnect(connection.callable)
