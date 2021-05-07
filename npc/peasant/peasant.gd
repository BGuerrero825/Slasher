extends NPC


var in_charge_range : bool = false

func _on_charge_range_area_entered(area):
	in_charge_range = true

func _on_charge_range_area_exited(area):
	in_charge_range = false
