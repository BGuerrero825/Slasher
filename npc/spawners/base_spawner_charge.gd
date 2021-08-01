extends Node2D


func _ready():
	var waypoint_list = $waypoint_list.get_children()
	var npc_list = $npc_list.get_children()
	
	for i in range(len(npc_list)):
		npc_list[i].waypoint = waypoint_list[i].position
		npc_list[i].stance = 'charge'
#		print(npc_list[i].waypoint)
		print(waypoint_list[i].position)
	
#	# set npc waypoints to position2d locations
#	for waypoint in $waypoint_list.get_children():
#		pass
#
#	# set all npc.stance to 'charge'
#	for npc in $npc_list.get_children():
#		npc.stance = 'charge'
