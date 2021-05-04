extends BasePlayerState

var mult = 1
var dir = Vector2.ZERO

func enter(player : KinematicBody2D):
	.enter(player)
	player.velocity = player.input_vector.normalized() * player.dodge_impulse

func run(player : KinematicBody2D):
	if not player.animation_player.is_playing():
		player.recovery_time = player.dodge_recovery_time
		return "recovery"
	
	player.velocity = player.velocity * mult
	if(mult > 0):
		mult -= .01


func exit(player: KinematicBody2D):
	.exit(player)
	player.velocity = Vector2.ZERO
	mult = 1
