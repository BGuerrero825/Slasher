extends BaseNPCState

func enter(npc : KinematicBody2D):
	npc.play("idle")


# the player is in range and the player is actively fighting the player (advancing, etc)
func run(npc: KinematicBody2D):
	if npc.stance != 'fight':
		return "idle"
	
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos))
	
	npc.move_direction = Vector2.UP
	
	if npc.in_attack_range:
		return "windup"
