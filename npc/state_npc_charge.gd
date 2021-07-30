extends BaseNPCState


func enter(npc : KinematicBody2D):
	npc.play("idle")


func run(npc: KinematicBody2D):
	npc.rotate_towards(npc.waypoint, 1)  # spin towards waypoint super fast
	npc.strafe_move(Vector2.UP, npc.speed*3)
	
	if npc.position.distance_to(npc.waypoint) < 10:
		npc.stance = "fight"
		return "idle"
	
