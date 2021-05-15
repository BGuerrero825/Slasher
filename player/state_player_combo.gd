extends BasePlayerState

var combo_queued = false
var sound_trigger

func enter(player : KinematicBody2D):
	.enter(player)
	player.sounds.queue("quick_swoosh", 0.15)

func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.light_recovery_time
		return "recovery"
		
	#if combo was queued, move to heavy hit at end of anim
	if combo_queued and player.animation_player.current_animation_position > 0.5:
		combo_queued = false
		return "heavy"
	
	#if attack pressed, queue the state change
	if Input.is_action_just_pressed("attack") and player.animation_player.current_animation_position < 0.55:
		combo_queued = true
