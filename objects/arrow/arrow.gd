extends KinematicBody2D

export var speed := 5
var move_dir := Vector2.ZERO


func _ready():
	move_dir = Vector2(0, speed).rotated(self.rotation)

func _process(delta):
	move_and_collide(move_dir)
