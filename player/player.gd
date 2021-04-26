extends KinematicBody2D

class_name Player

const NEW_NPC = preload("res://npc/knight/knight.tscn")
export var player_health = 40



#movement constants
export var MAX_SPEED := 150.0
export var ACCELERATION := 800.0
export var FRICTION := 550.0

export var heavy_attack_charge_time : float = 1.0
export var light_attack_window : float = 0.15

export var light_recovery_time : float = 0.2
export var heavy_recovery_time : float = 2.5
var recovery_time : float = 100.0  # SET IN STATE MACHINE

export var light_attack_dmg : float = 5.0
export var heavy_attack_dmg : float = 15.0
var active_dmg : float = 0.0  # SET IN STATE MACHINE


## REFACTOR BELOW
export var PARRY_COOLDOWN_TIME := .4

export var PARRY_INVINCIBILITY_TIME := .8

export var KNOCKBACK_TIME := 0.1  # total time spent in knockback
export var KNOCKBACK_STRENGTH := 40.0  # knockback strength

export var DODGE_TIMER = 0.2
export var DODGE_COOLDOWN_TIME := 0.50
export var DODGE_IMPULSE := 375

var parry_available := true
var invincible := false

var last_dmg_source = self

var input_vector := Vector2.ZERO
var velocity := Vector2.ZERO
var mouse_angle := 0.0
var movement_allowed := true
var dodge_allowed := true

var dodge_vel : Vector2 = Vector2(0.0, 0.0)

onready var center = $center
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var state_machine: PlayerFSM = $state_machine

func _ready():
	$"/root/Global".register_player(self)
	state_machine.init(self)

func _process(delta):
	state_machine.run()
	# display state
	$debug_state.text = state_machine.active_state.tag
	
	# COMBAT CODE
#	match current_state:

#
#		PARRY:
#			$debug_state.text = 'PARRY'
#			animation_player.play("Parry")
#			current_state = ATTACK_COOLDOWN
#			$attack_cooldown_timer.start(PARRY_COOLDOWN_TIME)
#
#		ATTACK_COOLDOWN:
#			$debug_state.text = 'ATTACK_COOLDOWN'
#			$light_windup_timer.stop()
#			$heavy_windup_timer.stop()
#
#		KNOCKBACK:
#			$debug_state.text = 'KNOCKBACK'
#
#			movement_allowed = false
#			if not $knockback_timer.time_left > 0:
#				$knockback_timer.start(KNOCKBACK_TIME)
#
#			$debug_state.text = "KNOCK_BACK"
#			velocity.x = -cos($center.rotation)
#			velocity.y = -sin($center.rotation)
#			velocity = KNOCKBACK_STRENGTH * velocity.normalized()
#
#		DODGE:
#			$debug_state.text = 'DODGE'
#			animation_player.play("Dodge")
#			if dodge_allowed:
#				velocity = input_vector.normalized() * DODGE_IMPULSE
#			movement_allowed = false
#			dodge_allowed = false
#			invincible = true
#			if not $dodge_timer.time_left > 0:
#				$dodge_timer.start(DODGE_TIMER)
#
#		DODGE_RECOVERY:
#			$debug_state.text = 'DODGE_RECOVERY'
#			if not $dodge_cooldown_timer.time_left > 0:
#				$dodge_cooldown_timer.start(DODGE_COOLDOWN_TIME)
			
	#debug code for spawning an enemy
	if Input.is_action_just_released("5"):
		var new_NPC = NEW_NPC.instance()
		get_tree().get_root().add_child(new_NPC)
			
	
	# Parry allowed in following states
#	if Input.is_action_just_pressed("block") and parry_available:# and current_state in []:
#		current_state = PARRY
	
	# MOVEMENT CODE
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	if movement_allowed:
		input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		input_vector = input_vector.normalized()
		if input_vector != Vector2.ZERO:
	#		if walking:
	#			input_vector = input_vector/2
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
#		if dodge_allowed and input_vector != Vector2.ZERO and Input.is_action_just_pressed("dodge"):
#			current_state = DODGE
	
	velocity = move_and_slide(velocity)
	mouse_angle = rad2deg(self.get_global_transform().get_origin().angle_to_point(get_global_mouse_position()))
	center.rotation_degrees = mouse_angle - 180


func play(anim:String):
	if animation_player.current_animation == anim:
		return
	animation_player.play(anim)


func _on_hitbox_area_entered(area):
	area.take_damage(active_dmg, self)


#func _on_hurtbox_damage_taken(amount, source):	
#	if not invincible:
#		player_health -= amount
#		print("Player_Health: ", player_health)
#		last_dmg_source = source
#		current_state = KNOCKBACK
#	else:
#		print("BLOCKED ATTACK WITH I FRAME")
#
#	if player_health <= 0:
#		print("PLAYER IS DEAD. (just block lul)")


func _on_blockbox_blocked_attack():
	$parry_invincible_timer.start(PARRY_INVINCIBILITY_TIME)
	invincible = true


#func _on_parry_invincible_timer_timeout():
#	invincible = false
#
#
#func _on_knockback_timer_timeout():
#	current_state = ATTACK_READY
#	movement_allowed = true
#
#
#func _on_dodge_timer_timeout():
#	current_state = DODGE_RECOVERY
#	movement_allowed = true
#	invincible = false
#	velocity = Vector2(0.0, 0.0)
#
#
#func _on_dodge_cooldown_timer_timeout():
#	dodge_allowed = true
#	current_state = ATTACK_READY
