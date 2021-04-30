extends Area2D

signal blocked_attack

func take_damage(amount, dmg_source):
	emit_signal("blocked_attack")
