extends BasePlayerState


func enter(player : KinematicBody2D):
	.enter(player)
	player.attacking = true
	player.sounds.queue("heavy_swoosh", 0.25)
	player.active_dmg = player.heavy_attack_dmg


func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.heavy_recovery_time
		return "recovery"

func exit(player : KinematicBody2D):
	.exit(player)
	player.attacking = false
