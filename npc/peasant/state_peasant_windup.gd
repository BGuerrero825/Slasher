extends BaseNPCState


func enter(npc : KinematicBody2D):
	.enter(npc)
	npc.speed = 90


func run(npc : KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
#	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos))
	
	if npc.in_attack_range:
		return "attack"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.SPEED
