extends BaseNPCState


func run(npc: KinematicBody2D):
	if npc.in_attack_range:
		return "attack"
