extends BaseNPCState

var cooldown_timer : SceneTreeTimer


func enter(player : KinematicBody2D):
	.enter(player)
	cooldown_timer = get_tree().create_timer(player.recovery_time)


func run(player : KinematicBody2D):
	if cooldown_timer.time_left <= 0:
		return "idle"
