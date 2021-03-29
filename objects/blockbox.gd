extends Area2D

signal blocked_attack

func take_damage(amount):
	emit_signal("blocked_attack")
