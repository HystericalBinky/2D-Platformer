extends Node

# MUSIC
const MENU = preload("res://Music/Menu.mp3")
const PLAINS = preload("res://Music/Plains.mp3")

# SOUND EFFECTS
const STEP = preload("res://Sounds/Step_Grass.mp3")
const JUMP = preload("res://Sounds/Jump.wav")
const LAND = preload("res://Sounds/Landing.wav")
const LOSE = preload("res://Sounds/Lose.wav")
const COLLECT = preload("res://Sounds/Pickup.wav")

onready var audioPlayers = $AudioPlayers

var is_playing_walk = false

func _ready():
	Events.connect("resetAllSounds", self, "_stop_all_sounds")

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break

func play_walking_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing and not audioStreamPlayer.stream == sound and not is_playing_walk == true:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			is_playing_walk = true
			break
			
func stop_walking_sound():
	for audioStreamPlayer in audioPlayers.get_children():
		if audioStreamPlayer.playing and audioStreamPlayer.stream == STEP:
			audioStreamPlayer.stream = null
			audioStreamPlayer.playing = false
			is_playing_walk = false
			break

func _stop_all_sounds():
	for audioStreamPlayer in audioPlayers.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stream = null
			audioStreamPlayer.playing = false
			break
