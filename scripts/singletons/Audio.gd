extends Node

var auto_play_music = true
var move_sounds = []
var capture_sounds = []
var music_loop = []
var music_player : AudioStreamPlayer
var sound_player : AudioStreamPlayer

func _ready():
	randomize()
	music_loop.append(load("res://audio/MusicLoop/347848__foolboymedia__new-york-jazz-loop.wav"))
	capture_sounds.append(load("res://audio/PieceCapture/chipLay3.ogg"))
	move_sounds.append(load("res://audio/PieceMove/chipLay1.ogg"))
	#load_audio_files_to("res://Audio/PieceCapture", capture_sounds)
	#load_audio_files_to("res://Audio/PieceMove", move_sounds)
	#load_audio_files_to("res://Audio/MusicLoop", music_loop)
	if (music_loop.size() > 0):
		print("Starting music loop...")
		music_player = AudioStreamPlayer.new()
		music_player.autoplay = auto_play_music
		music_player.stream = music_loop[0]
		add_child(music_player)
	if (move_sounds.size() > 0 and capture_sounds.size() > 0):
		sound_player = AudioStreamPlayer.new()
		sound_player.autoplay = false
		add_child(sound_player)

func play_move_sound():
	var rand_idx = randi() % move_sounds.size()
	var sound = move_sounds[rand_idx]
	sound_player.stream = sound
	sound_player.play()

func play_capture_sound():
	var rand_idx = randi() % capture_sounds.size()
	var sound = capture_sounds[rand_idx]
	sound_player.stream = sound
	sound_player.play()

func load_audio_files_to(str_dir : String, file_list = null):
	if (file_list == null):
		file_list = []
	var dir : Directory = Directory.new()
	dir.open(str_dir)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and not dir.current_is_dir():
			if (file.ends_with(".ogg") or file.ends_with(".wav")):
				file_list.append(load(dir.get_current_dir() + "/" + file))
	dir.list_dir_end()
	return file_list
