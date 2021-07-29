extends BaseNPCState

var hesitation_timer : SceneTreeTimer
var current_rotation : float
var direction_vector := Vector2.UP


func enter(npc : KinematicBody2D):
	hesitation_timer = get_tree().create_timer(npc.attack_hesitation_time)
	npc.randomize_attack_hesitation()
	#set a movement direction (forward, backward, or still) based on distance from player
	var distance_to_player = (npc.global_position - npc.player_ref.global_position).length()
	if distance_to_player < 200:
		direction_vector = Vector2.DOWN
	elif distance_to_player > 350:
		direction_vector = Vector2.UP
	else:
		direction_vector = Vector2.ZERO


# the player is in range and the player is actively fighting the player (advancing, etc)
func run(npc: KinematicBody2D):
	if !direction_vector == Vector2.ZERO:
		npc.play("idle")
	if npc.stance != 'fight':
		return "idle"
	
	# movement
	var player_pos = npc.player_ref.get_position()
	npc.rotate_towards(player_pos)
	npc.strafe_move(direction_vector, npc.speed)
	
	if npc.player_ref.attacking and npc.in_attack_range(player_pos):
		return "defend"

	if hesitation_timer.time_left <= 0:
		if npc.looking_at_player:
			return "windup"
