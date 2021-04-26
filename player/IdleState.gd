extends BasePlayerState


func run(player : KinematicBody2D):
	if Input.is_action_just_pressed("attack"):
		return "prep"  # enter "prep" state
