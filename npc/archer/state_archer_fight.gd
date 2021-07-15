extends BaseNPCState

var hesitation_timer : SceneTreeTimer
var current_rotation : float


func enter(npc : KinematicBody2D):
	npc.play("idle")
	hesitation_timer = get_tree().create_timer(npc.attack_hesitation_time)
	npc.randomize_attack_hesitation()


# the player is in range and the player is actively fighting the player (advancing, etc)
func run(npc: KinematicBody2D):
	if npc.stance != 'fight':
		return "idle"
	
	# movement
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	npc.strafe_move(Vector2.DOWN, npc.speed)
	
	if npc.player_ref.attacking and npc.in_attack_range(player_pos):
		return "defend"

	if hesitation_timer.time_left <= 0:
		if npc.looking_at_player:
			return "attack"
