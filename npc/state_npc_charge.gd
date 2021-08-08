extends BaseNPCState


func enter(npc : KinematicBody2D):
	npc.play("idle")


func run(npc: KinematicBody2D):
	npc.rotate_towards(npc.waypoint_list[0], 1)  # spin towards waypoint super fast
	npc.strafe_move(Vector2.UP, npc.speed*3)
	
	# reached waypoint
	if npc.position.distance_to(npc.waypoint_list[0]) < 10:
		npc.waypoint_list.pop_front()  # remove first waypoint (reached)
		
		if len(npc.waypoint_list) <= 0:  # all waypoints reached
			npc.reached_last_waypoint()
			npc.stance = "disabled"  # rely on other nodes (spawner) to change stance
		
		return "idle"
	
