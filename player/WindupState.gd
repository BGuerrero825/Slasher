extends BasePlayerState

var heavy_timer : SceneTreeTimer


func enter(player : KinematicBody2D):
	.enter(player)
	
	heavy_timer = get_tree().create_timer(player.heavy_attack_charge_time)


func run(player : KinematicBody2D):
	if Input.is_action_just_released("attack"):
		return "heavy"
	
	# heavy timer ends, enter heavy state
	if heavy_timer.time_left <= 0:
		return "heavy"
	
	if Input.is_action_just_pressed("block"):
		return "parry"

