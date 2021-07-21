extends Area2D

export var speed := 450
var move_dir := Vector2.ZERO
var arrow_life := 5
export var damage := 1


func _ready():
	move_dir = Vector2(0, speed).rotated(self.rotation)
	$arrow_life.wait_time = arrow_life
	$arrow_life.start()

func _process(delta):
	position += move_dir * delta
	#move_and_collide(move_dir)

func take_damage(amount, source):
	queue_free()

func _on_arrow_life_timeout():
	queue_free()

func _on_hitbox_area_entered(area):
	area.take_damage(damage, self)
