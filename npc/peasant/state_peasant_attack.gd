extends BaseNPCState


# play attack animations specifically from here
func enter(npc: KinematicBody2D):
	npc.play('heavy')


func run(npc: KinematicBody2D):
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "recovery"
	
	if npc.lunging:
		npc.speed = npc.lunge_speed
	elif not npc.lunging:
		npc.speed = npc.base_speed
	
	# movement
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	npc.strafe_move(Vector2.UP, npc.speed)


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
