extends KinematicBody2D


export var player_health = 40

#movement constants
export var MAX_SPEED := 85.0
export var ACCELERATION := 500.0
export var FRICTION := 350.0

export var LIGHT_ATTACK_COOLDOWN_TIME := .5
export var HEAVY_ATTACK_COOLDOWN_TIME := 1.0
export var PARRY_COOLDOWN_TIME := .4

export var PARRY_INVINCIBILITY_TIME := .8

export var LIGHT_ATTACK_WINDOW := .8
export var HEAVY_ATTACK_WINDOW := .5

export var LIGHT_ATTACK_DMG := 1
export var HEAVY_ATTACK_DMG := 2

export var KNOCKBACK_TIME := 0.1  # total time spent in knockback
export var KNOCKBACK_STRENGTH := 40.0  # knockback strength

enum {ATTACK_READY, LIGHT_WINDUP, HEAVY_WINDUP, LIGHT_ATTACKING, HEAVY_ATTACKING, ATTACK_COOLDOWN, PARRY, KNOCKBACK}

var attack_state := ATTACK_READY

var parry_available := true
var invincible := false

var current_damage := 0.0
var last_dmg_source = self

var velocity := Vector2.ZERO
var mouse_angle := 0.0
var movement_allowed := true

onready var center = $center
onready var animation = $center/AnimationPlayer

func _ready():
	$"/root/Global".register_player(self)
#	animation.play("Idle")

func _process(delta):

	# COMBAT CODE
	match attack_state:
		ATTACK_READY:
			$Label.text = 'ATTACK_READY'
			if Input.is_action_pressed("attack"):
				attack_state = LIGHT_WINDUP
				# start light to heavy attack transition timer
				$light_windup_timer.start(LIGHT_ATTACK_WINDOW)
		
		LIGHT_WINDUP:
			$Label.text = 'LIGHT_WINDUP'
			animation.play("Prep")
			if Input.is_action_just_released("attack"):
				attack_state = LIGHT_ATTACKING
		
		LIGHT_ATTACKING:
			$Label.text = 'LIGHT_ATTACKING'
			animation.play("Light")
			attack_state = ATTACK_COOLDOWN
			current_damage = LIGHT_ATTACK_DMG
			$attack_cooldown_timer.start(LIGHT_ATTACK_COOLDOWN_TIME)
		
		HEAVY_WINDUP:
			# heavy_windup_timer started in _on_light_windup_timer_timeout
			$Label.text = 'HEAVY_WINDUP'
			animation.play("Windup")
			if Input.is_action_just_released("attack"):
				attack_state = HEAVY_ATTACKING
		
		HEAVY_ATTACKING:
			$Label.text = 'HEAVY_ATTACKING'
			animation.play("Heavy")
			attack_state = ATTACK_COOLDOWN
			current_damage = HEAVY_ATTACK_DMG
			$attack_cooldown_timer.start(HEAVY_ATTACK_COOLDOWN_TIME)
		
		PARRY:
			$Label.text = 'PARRY'
			animation.play("Parry")
			attack_state = ATTACK_COOLDOWN
			$attack_cooldown_timer.start(PARRY_COOLDOWN_TIME)
		
		ATTACK_COOLDOWN:
			$light_windup_timer.stop()
			$heavy_windup_timer.stop()
		
		KNOCKBACK:
			movement_allowed = false
			if not $knockback_timer.time_left > 0:
				$knockback_timer.start(KNOCKBACK_TIME)
			
			$Label.text = "KNOCK_BACK"
			velocity.x = -cos($center.rotation)
			velocity.y = -sin($center.rotation)
			velocity = KNOCKBACK_STRENGTH * velocity.normalized()
	
	# Parry allowed in following states
	if Input.is_action_just_pressed("block") and parry_available:# and attack_state in []:
		attack_state = PARRY
	
	# MOVEMENT CODE
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	if movement_allowed:
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
	#		if walking:
	#			input_vector = input_vector/2
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	mouse_angle = rad2deg(self.get_global_transform().get_origin().angle_to_point(get_global_mouse_position()))
	center.rotation_degrees = mouse_angle - 180


func _on_attack_cooldown_timer_timeout():
	attack_state = ATTACK_READY


func _on_light_windup_timer_timeout():
	if attack_state == LIGHT_WINDUP:
		$heavy_windup_timer.start(HEAVY_ATTACK_WINDOW)
		attack_state = HEAVY_WINDUP


func _on_heavy_windup_timer_timeout():
	print("HEAVY_TIMEOUT")
	if attack_state == HEAVY_WINDUP:
		attack_state = HEAVY_ATTACKING


func _on_hitbox_area_entered(area):
	area.take_damage(current_damage)


func _on_hurtbox_damage_taken(amount, dmg_source):
#	print("DMG_SOURCE: ", dmg_source.position)
	
	if not invincible:
		player_health -= amount
		print("Player_Health: ", player_health)
		last_dmg_source = dmg_source
		attack_state = KNOCKBACK
	else:
		print("BLOCKED ATTACK WITH I FRAME")
	
	if player_health <= 0:
		print("PLAYER IS FUCKING DEAD")


func _on_blockbox_blocked_attack():
	$parry_invincible_timer.start(PARRY_INVINCIBILITY_TIME)
	invincible = true


func _on_parry_invincible_timer_timeout():
	invincible = false


func _on_knockback_timer_timeout():
	attack_state = ATTACK_READY
	movement_allowed = true
