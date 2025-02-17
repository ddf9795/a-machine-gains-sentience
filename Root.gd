extends Node2D

var music_tick = 0
var tick_target = 30

var blip_tick = 0
var blip_target = 15

func play_sound(name):
	for sound in $Sounds.get_children():
		if sound is AudioStreamPlayer:
			sound.playing = sound.name == name

func play_blip(name):
	for sound in $Sounds2.get_children():
		if sound is AudioStreamPlayer:
			sound.playing = sound.name == name

func _process(delta):
	music_tick += 1
	blip_tick += 1
	if music_tick >= tick_target:
		music_tick = 0
		tick_target = int(rand_range(10, 45))
		play_sound(str(int(rand_range(1,7))))
	if blip_tick >= blip_target:
		blip_tick = 0
		blip_target = int(rand_range(5, 20))
		play_blip(str(int(rand_range(1,4))))
	$"%Sine".pitch_scale = lerp($"%Sine".pitch_scale, $"%Sine".pitch_scale + rand_range(-0.5, 0.5), 0.01)
	$"%Whirr".pitch_scale = lerp($"%Whirr".pitch_scale, $"%Whirr".pitch_scale + rand_range(-0.5, 0.5), 0.08)
	if int(rand_range(0, 100)) == 50:
		$"%Whirr".playing = !$"%Whirr".playing
