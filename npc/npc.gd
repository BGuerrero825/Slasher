extends KinematicBody2D

class_name NPC

export var health := 25.0
export var SPEED := 35.0
var speed : float = SPEED

# NEW VARS
#################################################
var in_attack_range : bool = false
var in_runaway_range : bool = false

# Valid stances: 'disabled', 'charge', 'search', 'fight', 'retreat'
export var stance : String = 'fight'

# For this to work, the player has to be added to the scene first (higher in the tree)
onready var player_ref : KinematicBody2D = $"/root/Global".player

var move_direction : Vector2 = Vector2.ZERO

export var heavy_recovery_time : float = 1.5
var recovery_time : float = 1.0

export var lunging : bool = false  # set in animation player


export var ATTACK_DELAY_TIME := 0.01  # delay before initiating an attack while in range
export var ATTACK_COOLDOWN_TIME := 1.5  # delay between attacks
export var MOVE_DELAY_TIME := 0.5  # delay before moving after attacking
export var KNOCKBACK_TIME := 0.1  # total time spent in knockback
export var KNOCKBACK_STRENGTH := 40.0  # knockback strength
export var LUNGE_SPEED := 50.0  # lunge speed

export var DAMAGE := 10.0

export var ROTATE_SPEED := 10.0  # speed the character rotates towards the player

onready var STANDOFF_DISTANCE : float = 150 #$range_ref/standoff_distance.shape.radius  # distance the AI wants to sit from the player
onready var RUNAWAY_DISTANCE : float = 150 #$range_ref/runaway_distance.shape.radius  # distance the AI wants to run from the player

onready var animation_player := $AnimationPlayer
onready var state_machine := $npc_state_machine

var attack_available := true
var current_damage := DAMAGE

var velocity := Vector2.ZERO


func _ready():
	state_machine.init(self)


func _process(delta):
	state_machine.run()
	# display state
	$debug_state.text = state_machine.active_state.tag
	
	# movement
	if move_direction == Vector2.UP:
		velocity.x = cos($center.rotation)
		velocity.y = sin($center.rotation)
		velocity = speed * velocity.normalized()
	velocity = move_and_slide(velocity)


func rotate_towards(angle):
	$center.rotation = angle

func _on_hurtbox_npc_damage_taken(amount):
#	current_state = KNOCK_BACK
	health = health - amount
	print("NPC_Health: ", health, " damage taken: ", amount)
	if health <= 0:
		queue_free()


func play(anim:String):
	if animation_player.current_animation == anim:
		return
	animation_player.play(anim)


func _on_cooldown_timer_timeout():
	attack_available = true


func _on_hitbox_area_entered(area):
	area.take_damage(current_damage, self)


func _on_standoff_distance_area_entered(area):
	in_attack_range = true

func _on_standoff_distance_area_exited(area):
	in_attack_range = false



func _on_runaway_distance_area_entered(area):
	in_runaway_range = true

func _on_runaway_distance_area_exited(area):
	in_runaway_range = false
