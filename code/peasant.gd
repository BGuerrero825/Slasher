extends "res://code/npc.gd"


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
			$AnimationPlayer2.play("Heavy")
			
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
