extends BaseNPCState


func enter(npc : KinematicBody2D):
	npc.sounds.play("bow_draw")
	npc.play("windup")


func run(npc: KinematicBody2D):
	npc.rotate_towards(npc.player_ref.get_position(), 0.02)
	if not npc.animation_player.is_playing():
		npc.recovery_time = npc.heavy_recovery_time
		return "attack"
