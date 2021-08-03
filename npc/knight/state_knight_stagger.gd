extends BaseNPCState

var cooldown_timer : SceneTreeTimer

func enter(npc : KinematicBody2D):
	.enter(npc)


func run(npc : KinematicBody2D):
	if not npc.animation_player.is_playing():
#		npc.recovery_time = npc.heavy_recovery_time
		return "idle"


#func exit(npc : KinematicBody2D):
#	.exit(npc)
#	npc.speed = npc.base_speed
