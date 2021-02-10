extends KinematicBody2D


#movement constants
export var MAX_SPEED = 150
export var ACCELERATION = 1000
export var FRICTION = 750

var velocity = Vector2.ZERO
var mouse_angle = 0.0
onready var center = $base/center
onready var sprite = $base/center/sprite

func _ready():
	pass # Replace with function body.

func _process(delta):
	#shity attack anim logic
	if Input.is_action_pressed("attack"):
		sprite.frame = 1
	else: 
		sprite.frame = 0
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
		
func move():
	velocity = move_and_slide(velocity)

func orient():
	mouse_angle = rad2deg(self.get_global_transform().get_origin().angle_to_point(get_global_mouse_position()))
	self.get_node("base/center").rotation_degrees = mouse_angle - 180
