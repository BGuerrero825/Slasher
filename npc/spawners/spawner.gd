extends Node2D

# NPC preloads
const NPC_KNIGHT = preload("res://npc/knight/knight.tscn")
const NPC_PEASANT = preload("res://npc/peasant/peasant.tscn")
const NPC_ARCHER = preload("res://npc/archer/archer.tscn")



func _ready():
	print("TEST SPAWNER")
	

func spawn_npc(npc_preload):
	var new_npc = npc_preload.instance()
	new_npc.position = $spawn_point.global_position
	get_tree().get_current_scene().add_child(new_npc)


func _process(delta):
	#debug code for spawning an enemy
	if Input.is_action_just_released("5"):
		spawn_npc(NPC_KNIGHT)
		
	if Input.is_action_just_released("4"):
		spawn_npc(NPC_PEASANT)
		
	if Input.is_action_just_released("3"):
		spawn_npc(NPC_ARCHER)
