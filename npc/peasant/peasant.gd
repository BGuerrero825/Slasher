extends NPC


var in_charge_range : bool = false

export var charge_rotate_speed : float = 0.005
export var charge_time : float = 1.5

export var charge_speed : float = 90
export var charge_acceleration : float = 0.05

func _on_charge_range_area_entered(area):
	in_charge_range = true

func _on_charge_range_area_exited(area):
	in_charge_range = false
