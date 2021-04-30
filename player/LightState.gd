extends BasePlayerState


func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.light_recovery_time
		return "recovery"
