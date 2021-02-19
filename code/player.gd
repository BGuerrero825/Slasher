extends KinematicBody2D


#movement constants
export var MAX_SPEED = 150
export var ACCELERATION = 1000
export var FRICTION = 750
export var HEAVY_ATTACK_DELAY = 0.3
export var ATTACK_COOLDOWN_TIME = 0.6
var attack_cooldown = 0.0
var attack_delay = 0.0
var velocity = Vector2.ZERO
var mouse_angle = 0.0
onready var center = $center
onready var animation = $center/AnimationPlayer
#onready var sprite = $center/sprite
#onready var hitbox = $center/hitbox
#onready var hitbox_collision_shape = $center/hitbox/CollisionShape2D
#onready var blockbox = $center/blockbox
#onready var hurtbox = $hurtbox

export var light_attack_dmg = 1
export var heavy_attack_dmg = 2

func _ready():
	pass

func _process(delta):

	# COMBAT CODE
	#print(attack_cooldown)
#	attack_cooldown -= delta
	if attack_cooldown < 0:  # not in cooldown
		if Input.is_action_pressed("attack"):
			attack_delay += delta
			if attack_delay > HEAVY_ATTACK_DELAY:
				animation.play("Windup")
		elif Input.is_action_just_released("attack"):
			#print(attack_delay)
			if attack_delay > HEAVY_ATTACK_DELAY:
				$Label.text = 'HEAVY ATTACK'
				animation.play("Heavy")
			else:
				$Label.text = 'LIGHT ATTACK'
				animation.play("Light")
			attack_cooldown = ATTACK_COOLDOWN_TIME
		else:
			$Label.text = 'READY'
			animation.play("Idle")
			attack_delay = 0
	else:  # in cooldown
		
		attack_cooldown -= delta
	
	
	# MOVEMENT CODE
	#set input vector based on input strength from x axis (a/d) and y axis (w/s)
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	orient()



#func combat():
	#shity attack anim logic
#	if Input.is_action_pressed("attack"):
#		$center/hitbox/CollisionShape2D.disabled = false
#
#		$center/sprite.frame = 1
#	else:  # not attacking
#		$center/hitbox/CollisionShape2D.disabled = true
#
#		$center/sprite.frame = 0
	
#	if Input.is_action_pressed("block"):
#		blockbox.visible = true
#		blockbox.monitorable = true
#	else:
#		blockbox.visible = false
#		blockbox.monitorable = false
	


func move():
	velocity = move_and_slide(velocity)

func orient():
	mouse_angle = rad2deg(self.get_global_transform().get_origin().angle_to_point(get_global_mouse_position()))
	center.rotation_degrees = mouse_angle - 180

func _on_hitbox_area_entered(area):
	area.take_damage(20)
