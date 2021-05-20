extends BaseNPCState


func enter(npc : KinematicBody2D):
	.enter(npc)
	npc.speed = npc.windup_speed


func run(npc : KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	
	if not npc.animation_player.is_playing():
		return "attack"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
