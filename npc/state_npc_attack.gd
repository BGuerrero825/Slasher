extends BaseNPCState


# play attack animations specifically from here
func enter(npc: KinematicBody2D):
	npc.play('heavy')
	npc.speed = 50  # update with var

func run(npc: KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos))
	
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "recovery"
	
	if npc.lunging:
		npc.speed = 80
	elif not npc.lunging:
		npc.speed = 20


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.SPEED
