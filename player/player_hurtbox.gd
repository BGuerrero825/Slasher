extends Area2D

signal damage_taken(amount, dmg_source)

func take_damage(amount, dmg_source):
	emit_signal("damage_taken", amount, dmg_source)
