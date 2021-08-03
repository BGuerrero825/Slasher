extends Area2D

export var speed := 500
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
	print("hurtbox took damage")
	queue_free()

func _on_arrow_life_timeout():
	queue_free()

func _on_hitbox_area_entered(area):
	print("area entered hitbox")
	area.take_damage(damage, self)
	queue_free()

func _on_arrow_body_entered(body):
	print("body entered hurtbox")
	queue_free()
