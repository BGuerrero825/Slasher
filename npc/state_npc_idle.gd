extends BaseNPCState


func run(npc: KinematicBody2D):
	# Valid stances: 'disabled', 'charge', 'search', 'fight', 'retreat'
	if npc.stance == 'disabled':
		pass
	elif npc.stance == 'charge':
		return 'charge'
	elif npc.stance == 'search':
		return 'search'
	elif npc.stance == 'fight':
		return 'fight'
	elif npc.stance == 'retreat':
		return 'retreat'
