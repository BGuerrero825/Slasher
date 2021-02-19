extends KinematicBody2D


#movement constants
export var MAX_SPEED = 150
export var ACCELERATION = 1000
export var FRICTION = 750
export var HEAVY_ATTACK_DELAY = 1.0
export var LIGHT_ATTACK_COOLDOWN_TIME = .5
export var HEAVY_ATTACK_COOLDOWN_TIME = 1.0
export var HEAVY_ATTACK_CHARGE_TIME = .5

var attack_available = true
var heavy_attack = false
var attack_cooldown = 0.0
var attack_delay = 0.0
var velocity = Vector2.ZERO
var mouse_angle = 0.0

onready var center = $center
onready var attack_cooldown_timer = $attack_cooldown_timer
onready var heavy_attack_charge_timer = $heavy_attack_charge_timer

export var light_attack_dmg = 1
export var heavy_attack_dmg = 2

func _ready():
	$"/root/Global".register_player(self)

func _process(delta):

	# COMBAT CODE
	if attack_available:
		if Input.is_action_just_pressed("attack"):
			heavy_attack = false
			heavy_attack_charge_timer.start(HEAVY_ATTACK_CHARGE_TIME)

		elif heavy_attack:  # heavy attack charged up fully, auto release
			$Label.text = 'HEAVY ATTACK'
			begin_attack_cooldown(HEAVY_ATTACK_COOLDOWN_TIME)
			heavy_attack = false

		elif Input.is_action_just_released("attack") and attack_available:  # light attack
			$Label.text = 'LIGHT ATTACK'

			attack_available = false
			heavy_attack_charge_timer.stop()
			begin_attack_cooldown(LIGHT_ATTACK_COOLDOWN_TIME)


	# MOVEMENT CODE
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		if walking:
			input_vector = input_vector/2
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	if not oriented:
		orient()


func begin_attack_cooldown(time):
	attack_available = false
	attack_cooldown_timer.start(time)
	print("ATTACK_COOLDOWN: ", time)


func _on_heavy_attack_charge_timer_timeout():
	heavy_attack = true


func _on_attack_cooldown_timer_timeout():
	$Label.text = 'attack ready'
	attack_available = true


func move():
	velocity = move_and_slide(velocity)

func orient():
	mouse_angle = rad2deg(self.get_global_transform().get_origin().angle_to_point(get_global_mouse_position()))
	center.rotation_degrees = mouse_angle - 180

func _on_hitbox_area_entered(area):
	area.take_damage(20)
