extends KinematicBody2D


export var health = 25
export var speed = 10

var STANDOFF_DISTANCE = 40  # distance the AI wants to sit from the player
var RUNAWAY_DISTANCE = 25  # distance the AI wants to run from the player

enum {ATTACKING, STANDOFF, RETREATING, BACKING_AWAY, MOVING_TO_PLAYER, SLEEP}

var current_state = SLEEP

var ATTACK_DELAY_TIME = 0.5
var ATTACK_COOLDOWN_TIME = 1.5

var attack_available = true

var velocity = Vector2()

#onready var player_pos = $"/root/Global".player.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	var player_pos = $"/root/Global".player.get_position()
	var distance_to_player = position.distance_to(player_pos)
	
#	# orient towards player
	$center.rotation = PI + position.angle_to_point(player_pos)
	
	#$Label.text = str(position.distance_to(player_pos))
	
	# Stateful Code
	match current_state:
		ATTACKING:
			$Label.text = "ATTACKING"
			########################################################################################
			$AnimationPlayer.play("Light")  #TODO 
			$cooldown_timer.start(ATTACK_COOLDOWN_TIME)
			attack_available = false
		
		STANDOFF:  # attacking range
			$Label.text = "STANDOFF"
			velocity = Vector2.ZERO
			# intended to strafe/orbit around the player
#			velocity.x = cos($center.rotation)+PI/2
#			velocity.y = sin($center.rotation)+PI/2
#			velocity = speed * velocity.normalized()
			
			
			if attack_available and not $attack_timer.time_left > 0:  # only activate if timer isn't running
				$attack_timer.start(ATTACK_DELAY_TIME)
			
			if distance_to_player < RUNAWAY_DISTANCE:
				current_state = BACKING_AWAY
			elif distance_to_player > STANDOFF_DISTANCE:
				current_state = MOVING_TO_PLAYER
		
		RETREATING:
			$Label.text = "RETREATING"
		
		BACKING_AWAY:
			$Label.text = "BACKING_AWAY"
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = -speed * velocity.normalized()
			
			if distance_to_player > RUNAWAY_DISTANCE:
				current_state = STANDOFF
		
		MOVING_TO_PLAYER:
			$Label.text = "MOVING_TO_PLAYER"
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = speed * velocity.normalized()
			
			if distance_to_player < STANDOFF_DISTANCE:
				current_state = STANDOFF
		
		SLEEP:
			$Label.text = "SLEEP"
			if distance_to_player > STANDOFF_DISTANCE:
				current_state = MOVING_TO_PLAYER
	
	velocity = move_and_slide(velocity)


func _on_hurtbox_damage_taken(amount):
	health = health - amount
	print("health: ", health)
	if health <= 0:
		queue_free()


func _on_attack_timer_timeout():
	if current_state == STANDOFF or current_state == BACKING_AWAY:
		current_state = ATTACKING


func _on_cooldown_timer_timeout():
	attack_available = true
