extends KinematicBody2D


export var health = 25
export var speed = 10

var STANDOFF_DISTANCE = 40  # distance the AI wants to sit from the player
var RUNAWAY_DISTANCE = 25  # distance the AI wants to run from the player

enum {ATTACKING, STANDOFF, RETREATING, BACKING_AWAY, MOVING_TO_PLAYER, SLEEP}

var current_state = SLEEP

var velocity = Vector2()

#onready var player_pos = $"/root/Global".player.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	var player_pos = $"/root/Global".player.get_position()
	
#	# orient towards player
	$center.rotation = PI + position.angle_to_point(player_pos)
	
	$Label.text = str(position.distance_to(player_pos))
	
	# Stateful Code
	match current_state:
		ATTACKING:
			pass
		
		STANDOFF:  # attacking range
			velocity = Vector2.ZERO
			velocity.x = cos($center.rotation)+PI/2
			velocity.y = sin($center.rotation)+PI/2
			velocity = speed * velocity.normalized()
			
			
		
		RETREATING:
			pass
		
		BACKING_AWAY:
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = -speed * velocity.normalized()
		
		MOVING_TO_PLAYER:
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = speed * velocity.normalized()
		
		SLEEP:
			pass
	
	
	# move towards the player if far away
	var distance_to_player = position.distance_to(player_pos)
	
	if distance_to_player > STANDOFF_DISTANCE:
		current_state = MOVING_TO_PLAYER
	
	elif distance_to_player < RUNAWAY_DISTANCE:
		current_state = BACKING_AWAY
	
	else:  # fighting distance
		current_state = STANDOFF
	
	velocity = move_and_slide(velocity)


func _on_hurtbox_damage_taken(amount):
	health = health - amount
	print("health: ", health)
	if health <= 0:
		queue_free()

