extends Area2D

signal damage_taken(amount)

func take_damage(amount):
	emit_signal("damage_taken", amount)
