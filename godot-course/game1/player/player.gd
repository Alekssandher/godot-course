class_name Player
extends CharacterBody2D

@export_category("Moviment")
@export var speed: float = 3
@export_category("Sword")
@export var swordDamage: int = 2

@export_category("Power")
@export var powerDamage: int = 1
@export var powerInterval: float = 30
@export var powerScene: PackedScene

@export_category("Life")
@export var health: int = 100
@export var maxHealth: int = 100
@export var deathPrefab: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var swordArea: Area2D = $swordArea
@onready var hitboxArea: Area2D = $hitbox
@onready var healthProgressBar: ProgressBar = $healthProgressBar

var input_vector: Vector2 = Vector2(0, 0)
var isRunning: bool = false
var isAttacking: bool = false
var attackColdown: float = 0
var hitboxColdown: float = 0
var powerColdown: float = 30


var inputDir: Vector2
var i: int  = 1
var i2: int = 1


signal meatCollected(value: int)
signal moneyCollected(value: int)
func _ready():
	
	GameManager.player = self
	meatCollected.connect(func(value: int): GameManager.meatCounter += 1)
	moneyCollected.connect(func(value: int): GameManager.moneyCounter += 5)
func _process(delta: float) -> void:
	GameManager.playerPosition = position
	
	if i2 == 2:
		GameManager.timeElapsed = 0 
		
	i2 += 1
	readInput()
	if isAttacking:
		attackColdown -= delta
		if attackColdown <= 0.0:
			isAttacking = false
			isRunning = false
			animationPlayer.play("idle")
		pass
	
	
	if not isAttacking:
		rotateSprite()
		
	#process damdage
	updateHitboxDetection(delta)
	
	updatePower(delta)
	
	healthProgressBar.max_value = maxHealth
	healthProgressBar.value = health
	
func _physics_process(delta: float) -> void:
	#To change velocity
	var target_velocity = input_vector * speed * 100.0
	if isAttacking:
		target_velocity *= 0.15
		
	velocity = lerp(velocity, target_velocity, 0.05)
	move_and_slide()
	
	#To update is running 
	var wasRunning = isRunning
	isRunning = not input_vector.is_zero_approx()
	
	#To play animation
	if not isAttacking:
		if wasRunning != isRunning:
			if isRunning:
				animationPlayer.play("run")
			else:
				animationPlayer.play("idle")
			pass
func updatePower(delta: float):
	powerColdown -= delta
	if powerColdown > 0: return
	powerColdown = powerInterval
	
	var power = powerScene.instantiate()
	
	power.damageAmount = powerDamage
	add_child(power)
	
	
	pass
func rotateSprite():
	#To flip sprite
	if input_vector.x > 0: 
		sprite.flip_h = false
		pass
	elif input_vector.x < 0:
		sprite.flip_h = true
		pass
	
	#Attack
	if Input.is_action_just_pressed("attack"):
		attack()
func readInput() -> void:
	
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
		#deadzone 
	var deadzone = 0.15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
		
func attack() -> void:
	
	if isAttacking: 
		return
	attackColdown = 0.6
	
	if i%2 == 0:
		animationPlayer.play("attackSide2")
	else:
		animationPlayer.play("attackSide1")
	
	i += 1
	
	isAttacking = true
	
	
	
func damageEnemies():
	var bodies = swordArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var Enemy: enemy = body
			
			var directionToEnemy = (Enemy.position - position).normalized()
			var attackDirection: Vector2
			if sprite.flip_h:
				attackDirection = Vector2.LEFT
			else:
				attackDirection = Vector2.RIGHT
			var dotPtoduct = directionToEnemy.dot(attackDirection)
			
		
			
			if dotPtoduct >= 0.3:
				Enemy.damage(swordDamage)
	pass

func damage(amount: int):
	if health <= 0: return
	health -= amount
	
	
	#damagesignal
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)
	
	
	#Process death
	if health <= 0:
		die()
		
func die() -> void:
	GameManager.endGame()
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		
	queue_free()
	
func updateHitboxDetection(delta: float) -> void:
	
	hitboxColdown -= delta
	if hitboxColdown > 0: return
	
	hitboxColdown = 0.5
	
	var bodies = hitboxArea.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var Enemy: enemy = body
			var damageAmount = 1
			damage(damageAmount)
			
	pass	

func heal(amount: int):
	health += amount
	if health > maxHealth:
		health = maxHealth
	return health


func _on_virtual_joystick_analogic_chage(move: Vector2):
	input_vector = move
	

