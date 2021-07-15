extends BaseNPCState

const NEW_ARROW = preload("res://objects/arrow/arrow.tscn")

func enter(npc : KinematicBody2D):
	var new_Arrow = NEW_ARROW.instance()
	new_Arrow.position = npc.position  + Vector2(50, 0).rotated(npc.get_node("center").rotation)
	new_Arrow.rotation_degrees = npc.get_node("center").rotation_degrees - 90
	get_tree().get_current_scene().add_child(new_Arrow)
	print(npc.get_node("center").position)


func run(npc: KinematicBody2D):
	if npc.stance != 'fight':
		return "idle"
	return "fight"
