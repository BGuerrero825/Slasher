extends KinematicBody2D


export var health := 25.0
export var speed := 20.0

export var ATTACK_DELAY_TIME := 0.01  # delay before initiating an attack while in range
export var ATTACK_COOLDOWN_TIME := 1.5  # delay between attacks
export var MOVE_DELAY_TIME := 0.5  # delay before moving after attacking
export var KNOCKBACK_TIME := 0.1  # total time spent in knockback
export var KNOCKBACK_STRENGTH := 40.0  # knockback strength

export var DAMAGE := 10.0

onready var STANDOFF_DISTANCE : float = $range_ref/standoff_distance.shape.radius  # distance the AI wants to sit from the player
onready var RUNAWAY_DISTANCE : float = $range_ref/runaway_distance.shape.radius  # distance the AI wants to run from the player

enum {ATTACKING, STANDOFF, RETREATING, BACKING_AWAY, MOVING_TO_PLAYER, SLEEP, KNOCK_BACK}

var current_state := SLEEP

var attack_available := true

var velocity := Vector2()

#onready var player_pos = $"/root/Global".player.get_position()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _process(delta):
	var player_pos = $"/root/Global".player.get_position()
	var distance_to_player = position.distance_to(player_pos)
	
	# orient towards player
	$center.rotation = PI + position.angle_to_point(player_pos)
	
	#$debug_state.text = str(position.distance_to(player_pos))
	
	# Stateful Code
	match current_state:
		ATTACKING:
			$debug_state.text = "ATTACKING"
			$AnimationPlayer.play("Heavy")
			
			if not $timers/cooldown_timer.time_left > 0:
				$timers/cooldown_timer.start(ATTACK_COOLDOWN_TIME)
			if not $timers/move_delay_timer.time_left > 0:
				$timers/move_delay_timer.start(MOVE_DELAY_TIME)
			attack_available = false
		
		STANDOFF:  # attacking range
			$debug_state.text = "STANDOFF"
			velocity = Vector2.ZERO
			# intended to strafe/orbit around the player
#			velocity.x = cos($center.rotation)+PI/2
#			velocity.y = sin($center.rotation)+PI/2
#			velocity = speed * velocity.normalized()
			
			
			if attack_available and not $timers/attack_timer.time_left > 0:  # only activate if timer isn't running
				$timers/attack_timer.start(ATTACK_DELAY_TIME)
			
			if distance_to_player < RUNAWAY_DISTANCE:
				current_state = BACKING_AWAY
			elif distance_to_player > STANDOFF_DISTANCE:
				current_state = MOVING_TO_PLAYER
		
		RETREATING:
			$debug_state.text = "RETREATING"
		
		BACKING_AWAY:
			$debug_state.text = "BACKING_AWAY"
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = -speed * velocity.normalized()
			
			if distance_to_player > RUNAWAY_DISTANCE:
				current_state = STANDOFF
		
		MOVING_TO_PLAYER:
			$debug_state.text = "MOVING_TO_PLAYER"
			velocity.x = cos($center.rotation)
			velocity.y = sin($center.rotation)
			velocity = speed * velocity.normalized()
			
			if distance_to_player < STANDOFF_DISTANCE:
				current_state = STANDOFF
		
		KNOCK_BACK:
			if not $timers/knockback_timer.time_left > 0:
				$timers/knockback_timer.start(KNOCKBACK_TIME)
			
			$debug_state.text = "KNOCK_BACK"
			velocity.x = -cos($center.rotation)
			velocity.y = -sin($center.rotation)
			velocity = KNOCKBACK_STRENGTH * velocity.normalized()
		
		SLEEP:
			$debug_state.text = "SLEEP"
			if distance_to_player > STANDOFF_DISTANCE:
				current_state = MOVING_TO_PLAYER
	
	velocity = move_and_slide(velocity)


func _on_hurtbox_damage_taken(amount):
	current_state = KNOCK_BACK
	
	health = health - amount
	print("NPC_Health: ", health)
	if health <= 0:
		queue_free()


func _on_attack_timer_timeout():
	if current_state == STANDOFF or current_state == BACKING_AWAY:
		current_state = ATTACKING


func _on_cooldown_timer_timeout():
	attack_available = true


func _on_move_delay_timer_timeout():
	current_state = STANDOFF


func _on_hitbox_area_entered(area):
	area.take_damage(DAMAGE, self)


func _on_knockback_timer_timeout():
	current_state = STANDOFF
