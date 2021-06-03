extends KinematicBody2D

class_name Player, "res://art/helmet1_icon.png"


signal player_killed


const NEW_NPC = preload("res://npc/knight/knight.tscn")
export var player_health : float = 2.0

var attacking : bool = false

#movement constants
export var MAX_SPEED := 150.0
export var ACCELERATION := 800.0
export var FRICTION := 550.0

var base_rotation_speed : float = 0.3
var rotation_speed : float = base_rotation_speed
export var camera_offset_strength : float = .2
export var heavy_attack_charge_time : float = 1.5
export var light_attack_window : float = 0.45

export var light_recovery_time : float = 0.1
export var heavy_recovery_time : float = 0.2
export var parry_recovery_time : float = 0.2
export var dodge_recovery_time : float = 0.2
var recovery_time : float = 100.0  # SET IN STATE MACHINE

export var dodge_impulse : float = 450.0
export var light_attack_dmg : float = 1
export var heavy_attack_dmg : float = 2
var active_dmg : float = 0  # SET IN STATE MACHINE

export var parry_invincibility_time : float = .8

var invincible : bool = false
var flipped : bool = false
#var head_y := -100

#var last_dmg_source = self

var input_vector := Vector2.ZERO
var velocity := Vector2.ZERO
var mouse_angle := 0.0
var movement_allowed := true
var dodge_allowed := true

var dodge_vel : Vector2 = Vector2(0.0, 0.0)

onready var center = $center
onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var state_machine: PlayerFSM = $state_machine
onready var sounds = $sounds

func _ready():
	$"/root/Global".register_player(self)
	state_machine.init(self)

func _process(delta):
	#if $center/character.flip_h:
	#	$center/head.position.y *= -1
	state_machine.run()
	# display state
	$debug_state.text = state_machine.active_state.tag
#	$debug_state.text = str(invincible)

	#debug code for spawning an enemy
	if Input.is_action_just_released("5"):
		var new_NPC = NEW_NPC.instance()
#		get_tree().get_root().add_child(new_NPC)
		get_tree().get_current_scene().add_child(new_NPC)

	#debug code for flipping sprite
	if Input.is_action_just_released("1"):
		flip_character()

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
		# if inputing to move
		if input_vector != Vector2.ZERO:
	#		if walking:
	#			input_vector = input_vector/2
			velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
			# if at max speed
			if velocity.length() == MAX_SPEED:
				$sounds.play("grass")
		else:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			$sounds/grass.stop()

	velocity = move_and_slide(velocity)

	rotate_towards(get_global_mouse_position())
	#move camera based on mouse distance from player
	$Camera2D.transform.origin = (get_global_mouse_position() - get_global_transform().get_origin()) * camera_offset_strength


func rotate_towards(target_pos, target_rotation_speed = rotation_speed) -> float:
	var target_angle = PI + position.angle_to_point(target_pos)
	$center.rotation = lerp_angle($center.rotation, target_angle, target_rotation_speed)

	return $center.rotation + TAU/4


# reverse character sprite and head sprite when flipped
func flip_character():
	$center/character.scale.x *= -1
	$center/character/head.flip_h = !$center/character/head.flip_h
	flipped = !flipped

func play(anim:String):
	if animation_player.current_animation == anim:
		return
	animation_player.play(anim)


func _on_hitbox_area_entered(area):
	area.take_damage(active_dmg, self)
	#freeze animation on hit
	animation_player.play(animation_player.current_animation, 0.0, 0.0)
#	$hit_freeze_timer.start()
	$sounds.start("sword_slice")
	yield(get_tree().create_timer(0.1), "timeout")
	animation_player.play()


func _on_hurtbox_damage_taken(amount, source):
	if not invincible:
#		print("amount: ", amount, "  source: ", source)
		player_health -= amount
		sounds.play("oough")
		print("Player_Health: ", player_health)
		knockback(source)
	else:
		print("BLOCKED ATTACK WITH I FRAME")

	if player_health <= 0:
		print("YOU ARE DEAD.")
		emit_signal("player_killed")


# warning-ignore:unused_argument
func knockback(dmg_source):
	pass


func _on_blockbox_blocked_attack():
#	$parry_invincible_timer.start(parry_invincibility_time)
	invincible = true
	$sounds.start("sword_clash2")
	yield(get_tree().create_timer(parry_invincibility_time), "timeout")
	invincible = false


#func _on_parry_invincible_timer_timeout():
#	invincible = false
