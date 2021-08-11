extends BaseNPCState


# play attack animations specifically from here
func enter(npc: KinematicBody2D):
	npc.play('heavy')
	npc.sounds.queue("heavy_swoosh", 0.25)


func run(npc: KinematicBody2D):
	var player_pos = npc.player_ref.get_position()
	
	if npc.lunging:
		npc.speed = npc.lunge_speed
	elif not npc.lunging:
		npc.speed = npc.base_speed
	
	npc.rotate_towards(player_pos)
	npc.strafe_move(Vector2.UP, npc.speed)
	
	if npc.hit_blocking_player == true:
		npc.hit_blocking_player = false
		return "stagger"
	
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "recovery"


func exit(npc : KinematicBody2D):
	.exit(npc)
	npc.speed = npc.base_speed
