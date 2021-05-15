extends Node2D

var random_pitch_noises := ["light_swoosh", "heavy_swoosh", "quick_swoosh", "sword_clash", "sword_slice", "sword_clash_low"]
var pitch_variance := 0.2
var queued_sound = []
var queued_sound_times = []

onready var timer := -1.0

# starts a sound if its not already playing
func play(sound):
	if !get_node(sound).playing:
		if sound in random_pitch_noises:
			get_node(sound).pitch_scale = 1 + rand_range(pitch_variance * -1, pitch_variance)
		get_node(sound).play()
		
		
# starts a new sound regardless if its playing or not
func start(sound):
	if sound in random_pitch_noises:
		get_node(sound).pitch_scale = 1 + rand_range(pitch_variance * -1, pitch_variance)
	get_node(sound).play()
	
	
# queue a song to play in a certain amount of time
func queue(sound, time):
	# start timer if it was inactive
	if timer == -1:
		timer = 0
	queued_sound.append(sound)
	queued_sound_times.append(timer + time)

func _process(delta):
	# if queue is empty, disable timer
	if queued_sound.size() == 0:
		timer = -1
	# if timer is active
	if timer >= 0:
		timer += delta
		#iterate through array to check if sounds are ready to play
		var i = 0
		while i < queued_sound_times.size():
			# if timer has passed the queue time play it then remove it
			if timer > queued_sound_times[i]:
				start(queued_sound[i])
				queued_sound_times.remove(i)
				queued_sound.remove(i)
			i += 1
