extends BasePlayerState

var combo_queued = false


func enter(player : KinematicBody2D):
	.enter(player)
	player.attacking = true


func run(player : KinematicBody2D):
	# true when animation is complete
	if not player.animation_player.is_playing():
		player.recovery_time = player.light_recovery_time
		return "recovery"
	
	#if combo was queued, move to combo hit after swing
	if combo_queued and player.animation_player.current_animation_position > 0.25:
		combo_queued = false
		return "combo"
		
	#if attack pressed, queue the state change
	if Input.is_action_just_pressed("attack") and player.animation_player.current_animation_position < 0.3:
		combo_queued = true

func exit(player : KinematicBody2D):
	.exit(player)
	player.attacking = false
