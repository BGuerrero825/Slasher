extends BaseNPCState

func enter(npc : KinematicBody2D):
	npc.play("idle")


# the player is in range and the player is actively fighting the player (advancing, etc)
func run(npc: KinematicBody2D):
	if npc.stance != 'fight':
		return "idle"
	
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	npc.strafe_move(Vector2.UP, npc.speed)
	
	if npc.in_attack_range(player_pos):
		return "windup"
