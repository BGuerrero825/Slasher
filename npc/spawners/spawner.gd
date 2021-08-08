extends Node2D

# NPC preloads
const NPC_KNIGHT = preload("res://npc/knight/knight.tscn")
const NPC_PEASANT = preload("res://npc/peasant/peasant.tscn")
const NPC_ARCHER = preload("res://npc/archer/archer.tscn")

var npc_tracker := []

func _on_spawn_delay_timer_timeout():
	spawn_npc(NPC_KNIGHT, $B)
	yield(get_tree().create_timer(0.25), "timeout")
	spawn_npc(NPC_PEASANT, $A)
	yield(get_tree().create_timer(0.25), "timeout")
	var final_npc = spawn_npc(NPC_PEASANT, $C)
	
	yield(get_tree().create_timer(2.4), "timeout")  # timed to all npcs reaching final waypoint
	
	for npc in npc_tracker:
		npc.stance = "fight"

	for npc in npc_tracker:
		print(npc.stance)



func spawn_npc(npc_preload, final_position = $B):
	var new_npc = npc_preload.instance()
	new_npc.position = $spawn_point.global_position
	new_npc.stance = "charge"
	new_npc.waypoint_list = [$half_way.global_position, final_position.global_position]
	npc_tracker.append(new_npc)
	new_npc.connect("npc_killed", self, "_on_npc_killed")
	get_tree().get_current_scene().add_child(new_npc)
	
	return new_npc


func _on_reached_last_waypoint(npc):
	npc.stance = "fight"


func _on_npc_killed(npc):
#	print(npc, " killed")
	npc_tracker.erase(npc)


# only use for debug
func _process(delta):
	# debug code for spawning an enemy
	if Input.is_action_just_released("5"):
		var new_npc = spawn_npc(NPC_KNIGHT)
		new_npc.connect("reached_last_waypoint", self, "_on_reached_last_waypoint")
		
	if Input.is_action_just_released("4"):
		var new_npc = spawn_npc(NPC_PEASANT)
		new_npc.connect("reached_last_waypoint", self, "_on_reached_last_waypoint")
		
	if Input.is_action_just_released("3"):
		var new_npc = spawn_npc(NPC_ARCHER)
		new_npc.connect("reached_last_waypoint", self, "_on_reached_last_waypoint")
