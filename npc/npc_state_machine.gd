extends Node2D

class_name NPCFSM

var states : Dictionary = {}
var active_state : BaseNPCState
var npc : KinematicBody2D


func generate_state_dictionary():
	for state in get_children():
		if state.tag:
			states[state.tag] = state


func init(npc: KinematicBody2D):
	self.npc = npc
	generate_state_dictionary()
	active_state = states.idle
	active_state.enter(self.npc)


func run():
	var next_state_tag = active_state.run(npc)
	if next_state_tag:
		change_state(next_state_tag)


func change_state(var next_state_tag : String):
	var next_state = states.get(next_state_tag)
	if next_state:
		active_state.exit(npc)
		active_state = next_state
		active_state.enter(npc)
