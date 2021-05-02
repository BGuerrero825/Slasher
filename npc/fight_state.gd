extends BaseNPCState


var player_pos : Vector2

# the player is in range and the player is actively fighting the player (advancing, etc)
func run(npc: KinematicBody2D):
	if npc.stance != 'fight':
		return "idle"
	
	player_pos = npc.player_ref.get_position()
	npc.rotate_towards(PI + npc.position.angle_to_point(player_pos))
	
	npc.move_direction = Vector2.UP
	
	if npc.in_attack_range:
		return "attack"


func exit(npc: KinematicBody2D):
	.exit(npc)
	npc.move_direction = Vector2.ZERO
	npc.velocity = Vector2.ZERO
