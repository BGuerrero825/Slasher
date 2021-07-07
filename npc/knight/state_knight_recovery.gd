extends BaseNPCState

var cooldown_timer : SceneTreeTimer


func enter(npc : KinematicBody2D):
	.enter(npc)
	npc.speed = npc.recovery_speed
#	npc.speed = 100
	cooldown_timer = get_tree().create_timer(npc.recovery_time)
	npc.move_direction = Vector2.DOWN


func run(npc : KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
#	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos))
	
	npc.rotate_towards(player_pos)
	npc.strafe_move(Vector2.DOWN, npc.speed)
	
	if cooldown_timer.time_left <= 0:
		return "idle"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
