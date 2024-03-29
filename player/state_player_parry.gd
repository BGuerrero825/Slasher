extends BasePlayerState


func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.parry_recovery_time
		return "recovery"
	
	# counter attack input
	if player.invincible == true and Input.is_action_just_pressed("attack"):
		#skip to end of anim
		player.animation_player.advance(player.animation_player.current_animation_length)
		return "prep"
