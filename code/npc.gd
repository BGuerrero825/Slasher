extends KinematicBody2D


export var health = 25

# Called when the node enters the scene tree for the first time.
func _ready():
#	print($hurtbox.rpc_id())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_hurtbox_damage_taken(amount):
	health = health - amount
	print("health: ", health)
	if health <= 0:
		queue_free()
