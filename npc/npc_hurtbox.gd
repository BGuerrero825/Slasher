extends Area2D

signal npc_damage_taken(amount, source)

func take_damage(amount, source):
	emit_signal("npc_damage_taken", amount, source)
