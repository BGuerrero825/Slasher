extends BasePlayerState


func run(player : KinematicBody2D):
	if not player.animation_player.is_playing():
		player.recovery_time = player.dodge_recovery_time
		return "recovery"
	
	player.velocity = player.velocity.normalized() * player.dodge_impulse


func exit(player: KinematicBody2D):
	.exit(player)
	player.velocity = Vector2.ZERO
