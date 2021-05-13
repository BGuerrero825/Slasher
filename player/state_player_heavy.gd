extends BasePlayerState

var sound_trigger

func enter(player : KinematicBody2D):
	.enter(player)
	sound_trigger = 0

func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.heavy_recovery_time
		return "recovery"

	#play sound after 10 frames
	if sound_trigger == 10:
		player.play_sound("heavy_swoosh")
	
	sound_trigger += 1
