extends Area2D

signal npc_damage_taken(amount)

func take_damage(amount):
	emit_signal("npc_damage_taken", amount)
