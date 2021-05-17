extends BaseNPCState

#################
# CHARGE ATTACK #
#################

var charge_timer : SceneTreeTimer

func enter(npc : KinematicBody2D):
	.enter(npc)
#	npc.speed = npc.charge_speed
	npc.speed = 0
	
	charge_timer = get_tree().create_timer(npc.charge_time)


func run(npc : KinematicBody2D):
	# starts at current npc speed and increases over time
	npc.speed = lerp(npc.speed, npc.charge_speed, npc.charge_acceleration)
	
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos), npc.charge_rotate_speed)
	
	if npc.in_attack_range: # and npc.looking_at_player:
		return "attack"
	
	if charge_timer.time_left <= 0:
		return "recovery"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
