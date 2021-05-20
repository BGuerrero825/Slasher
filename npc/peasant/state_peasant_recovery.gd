extends BaseNPCState

var cooldown_timer : SceneTreeTimer
var rand_float : float

func enter(npc : KinematicBody2D):
	npc.play("idle")
	npc.speed = npc.recovery_speed
#	npc.speed = 100
	cooldown_timer = get_tree().create_timer(npc.recovery_time)
	npc.move_direction = Vector2.DOWN
	
	randomize()
	rand_float = randf()


func run(npc : KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	
	if npc.in_standoff_range(player_pos):
		npc.strafe_move(Vector2.DOWN, npc.recovery_speed)
	elif not npc.in_standoff_range(player_pos):
		if rand_float > 0.5:
			npc.strafe_move(Vector2.LEFT, npc.recovery_speed)
		else:
			npc.strafe_move(Vector2.RIGHT, npc.recovery_speed)
	
	if cooldown_timer.time_left <= 0:
		return "idle"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
