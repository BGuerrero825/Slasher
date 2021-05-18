extends KinematicBody2D

class_name NPC

export var health : float = 25.0
export var base_speed : float = 35.0
export var lunge_speed : float = 80.0
export var recovery_speed : float = 15.0
export var windup_speed : float = 5.0
var speed : float = base_speed

const corpse = preload("res://objects/corpse/corpse.tscn")
const blood = preload("res://objects/blood/blood.tscn")

# NEW VARS
#################################################
var in_attack_range : bool = false
var in_standoff_range : bool = false
var in_runaway_range : bool = false

# Valid stances: 'disabled', 'charge', 'search', 'fight', 'retreat'
export var stance : String = 'fight'

# For this to work, the player has to be added to the scene first (higher in the tree)
onready var player_ref : KinematicBody2D = $"/root/Global".player

var move_direction : Vector2 = Vector2.ZERO

export var heavy_recovery_time : float = 1.5
var recovery_time : float = 1.0

export var lunging : bool = false  # set in animation player

export var _rotation_speed : float = 0.025

var looking_at_player : bool = true  # set in rotate_towards func


export var damage : float = 45.0

onready var animation_player := $AnimationPlayer
onready var state_machine := $npc_state_machine

var attack_available := true
var current_damage := damage

var velocity := Vector2.ZERO

var attack_hesitation_time : float = 1.0


func _ready():
	state_machine.init(self)
	randomize_attack_hesitation()


func _process(delta):
	state_machine.run()
	# display state
	$debug_state.text = state_machine.active_state.tag
	
	# if player is dead, spawn a corpse then delete self
	if health <= 0:
		var new_corpse = corpse.instance()
		get_tree().get_root().add_child(new_corpse)
		new_corpse.transform = get_global_transform()
		new_corpse.rotation_degrees = $center.rotation_degrees - 90
		queue_free()

#	move_npc()


func move_npc():
	# movement
	if move_direction == Vector2.UP:
		velocity.x = cos($center.rotation)
		velocity.y = sin($center.rotation)
		velocity = speed * velocity.normalized()
	elif move_direction == Vector2.DOWN:  # backing off
		velocity.x = cos($center.rotation)
		velocity.y = sin($center.rotation)
		velocity = -speed * velocity.normalized()
	velocity = move_and_slide(velocity)
	

func rotate_towards(target_angle, target_rotation_speed = _rotation_speed):
	$center.rotation = lerp_angle($center.rotation, target_angle, target_rotation_speed)



#	# Tolerance for looking at player
#	if abs($center.rotation - target_angle) > 0.1:
#		looking_at_player = false
#	else:
#		looking_at_player = true


func randomize_attack_hesitation():
	attack_hesitation_time = rand_range(1, 3.5)


func _on_hurtbox_npc_damage_taken(amount, source):
#	current_state = KNOCK_BACK
	# spawn blood on hit
	var new_blood = blood.instance()
	get_tree().get_root().add_child(new_blood)
	new_blood.transform.origin = $center.get_global_transform().get_origin()
	new_blood.transform.origin += polar2cartesian(30, deg2rad(source.get_node("center").rotation_degrees + ((-1 if source.flipped else 1) * 90)))
	new_blood.rotation_degrees = $center.rotation_degrees + (int(source.flipped) * 180)
	new_blood.scale.x = (-1 if source.flipped else 1)
	health = health - amount
	print("NPC_Health: ", health, " damage taken: ", amount)


func play(anim:String):
	if animation_player.current_animation == anim:
		return
	animation_player.play(anim)


func _on_cooldown_timer_timeout():
	attack_available = true


func _on_hitbox_area_entered(area):
	area.take_damage(current_damage, self)


func _on_standoff_distance_area_entered(area):
	in_standoff_range = true

func _on_standoff_distance_area_exited(area):
	in_standoff_range = false



func _on_runaway_distance_area_entered(area):
	in_runaway_range = true

func _on_runaway_distance_area_exited(area):
	in_runaway_range = false


func _on_attack_distance_area_entered(area):
	in_attack_range = true

func _on_attack_distance_area_exited(area):
	in_attack_range = false
