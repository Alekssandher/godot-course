extends CharacterBody2D
@export var speed float: = 1

func _physics_process(delta):
	
	inputVector
	velocity = inputVector * speed * 100
	move_and_slide()
