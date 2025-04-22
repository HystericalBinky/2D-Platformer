extends Node2D

const PlayerScene = preload("res://Player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera = $Camera2D
onready var player = $Player
onready var timer = $Timer

onready var heartsContainer = $CanvasLayer/heartsContainer

func _ready():
	VisualServer.set_default_clear_color(Color.lightskyblue)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	Events.connect("player_died", self, "_on_Player_player_died")
	SoundPlayer.play_sound(SoundPlayer.PLAINS)
	Events.connect("hit_checkpoint", self, "_on_hit_checkpoint")

func _on_player_died():
	timer.start(2.5)
	yield(timer, "timeout")
	var player = PlayerScene.instance()
	player.position = player_spawn_location
	add_child(player)
	player.connect_camera(camera)

func _on_hit_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position


func _on_Player_player_died():
	pass # Replace with function body.
