extends BaseNPCState


func enter(npc : KinematicBody2D):
	npc.play("idle")
	npc.move_direction = Vector2.ZERO

func play(npc : KinematicBody2D):
	pass
	
#	npc.velocity.x = cos(npc.$center.rotation)
#	npc.velocity.y = sin(npc.$center.rotation)
	npc.velocity.x = 1
	npc.velocity = -npc.speed * npc.velocity.normalized()
	npc.velocity = npc.move_and_slide(npc.velocity)
