extends BasePlayerState

var light_timer : SceneTreeTimer


func enter(player : KinematicBody2D):
	.enter(player)
	light_timer = get_tree().create_timer(player.light_attack_window)


func run(player : KinematicBody2D):
	if Input.is_action_just_released("attack"):
		return "light"

	if light_timer.time_left <= 0:
		return "windup"
	
	if Input.is_action_just_pressed("block"):
		return "parry"

