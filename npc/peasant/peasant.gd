extends NPC


export var charge_rotate_speed : float = 0.005
export var charge_time : float = 1.5

export var charge_speed : float = 90
export var charge_acceleration : float = 0.05


func in_charge_range(player_pos) -> bool:
	var distance_to_player = position.distance_to(player_pos)
	var charge_range_radius = $charge_range/CollisionShape2D.shape.radius
#	print(distance_to_player, " - ", charge_range_radius)
	return distance_to_player < charge_range_radius
