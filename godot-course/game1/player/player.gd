class_name Player
extends CharacterBody2D

@export var speed: float = 3
@export var swordDamage: int = 2
@onready var sprite: Sprite2D = $Sprite2D
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var swordArea: Area2D = $swordArea

@export var health: int = 100
@export var maxHealth = 100
@export var deathPrefab: PackedScene
@onready var hitboxArea: Area2D = $hitbox


var input_vector: Vector2 = Vector2(0, 0)
var isRunning: bool = false
var isAttacking: bool = false
var attackColdown: float = 0
var hitboxColdown: float = 0


func _process(delta: float) -> void:
	readInput()
	if isAttacking:
		attackColdown -= delta
		if attackColdown <= 0.0:
			isAttacking = false
			isRunning = false
			animationPlayer.play("idle")
		pass
	GameManager.playerPosition = position
	
	if not isAttacking:
		rotateSprite()
		
	#process damdage
	updateHitboxDetection(delta)
	
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
	animationPlayer.play("attackSide1")
	
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
			
			print("Dot:", dotPtoduct)
			
			if dotPtoduct >= 0.3:
				Enemy.damage(swordDamage)
	pass

func damage(amount: int):
	if health <= 0: return
	health -= amount
	print("Player recebeu dano de ", amount, "e a vida atual é ", health)
	
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
	if deathPrefab:
		var deathObject = deathPrefab.instantiate()
		deathObject.position = position
		get_parent().add_child(deathObject)
		
	queue_free()
	
func updateHitboxDetection(delta: float):
	
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
