extends BaseNPCState

var dodge_timer : SceneTreeTimer
var dodge_speed : float

func enter(npc : KinematicBody2D):
	npc.play("idle")
	dodge_timer = get_tree().create_timer(0.1)
	dodge_speed = npc.speed * 5

func run(npc : KinematicBody2D):
	dodge_speed = lerp(dodge_speed, dodge_speed*4, 0.01)
	npc.strafe_move(Vector2.DOWN, dodge_speed)
	
	if dodge_timer.time_left <= 0:
		return "idle"
