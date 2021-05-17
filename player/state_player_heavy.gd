extends BasePlayerState


func enter(player : KinematicBody2D):
	.enter(player)
	player.attacking = true

func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.heavy_recovery_time
		return "recovery"
	#play sound after 10 frames
	if sound_trigger == 10:
		player.sounds.play("heavy_swoosh")

		sound_trigger += 1

func exit(player : KinematicBody2D):
	.exit(player)
	player.attacking = false
