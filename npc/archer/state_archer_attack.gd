extends BaseNPCState

const NEW_ARROW = preload("res://objects/arrow/arrow.tscn")
var firing_error_max := 8

func enter(npc : KinematicBody2D):
	npc.play("attack")
	var new_Arrow = NEW_ARROW.instance()
	var firing_error = randi() % (firing_error_max*2) - firing_error_max
	new_Arrow.position = npc.position  + Vector2(50, 0).rotated(npc.get_node("center").rotation)
	new_Arrow.rotation_degrees = npc.get_node("center").rotation_degrees - 90 + firing_error
	get_tree().get_current_scene().add_child(new_Arrow)


func run(npc: KinematicBody2D):
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "recovery"
