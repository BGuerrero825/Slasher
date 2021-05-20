extends BasePlayerState

var cooldown_timer : SceneTreeTimer


func enter(player : KinematicBody2D):
	player.play("idle")
	cooldown_timer = get_tree().create_timer(player.recovery_time)


func run(player : KinematicBody2D):
	if cooldown_timer.time_left <= 0:
		return "idle"
	
	if Input.is_action_just_pressed("block"):
		return "parry"
