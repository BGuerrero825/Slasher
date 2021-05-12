extends Node2D

var random_pitch_noises := ["light_swoosh", "heavy_swoosh", "quick_swoosh", "clash"]
var pitch_variance := 0.2

func play(sound):
	if !get_node(sound).playing:
		if sound in random_pitch_noises:
			get_node(sound).pitch_scale = 1 + rand_range(pitch_variance * -1, pitch_variance)
			get_node(sound).play()
		else:
			get_node(sound).play()
	
	
