extends KinematicBody2D


#movement constants
export var MAX_SPEED = 150
export var ACCELERATION = 1000
export var FRICTION = 750

export var LIGHT_ATTACK_COOLDOWN_TIME = .5
export var HEAVY_ATTACK_COOLDOWN_TIME = 1.0

export var LIGHT_ATTACK_WINDOW = .8
export var HEAVY_ATTACK_WINDOW = .5

export var LIGHT_ATTACK_DMG = 1
export var HEAVY_ATTACK_DMG = 2

enum {ATTACK_READY, LIGHT_WINDUP, HEAVY_WINDUP, LIGHT_ATTACKING, HEAVY_ATTACKING, ATTACK_COOLDOWN}

var attack_state = ATTACK_READY

var current_damage = 0

var velocity = Vector2.ZERO
var mouse_angle = 0.0

onready var center = $center
onready var animation = $center/AnimationPlayer

func _ready():
	$"/root/Global".register_player(self)

func _process(delta):
	if Input.is_action_pressed("block"):
		animation.play("Block")
		# walking = true
	elif Input.is_action_just_released("block"):
		animation.play("Idle")
		# walking = false

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

		ATTACK_COOLDOWN:
			$light_windup_timer.stop()
			$heavy_windup_timer.stop()

	# MOVEMENT CODE
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
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
	print("TEST")

	area.take_damage(current_damage)
