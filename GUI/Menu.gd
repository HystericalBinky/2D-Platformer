extends Control


func _ready():
	Events.emit_signal("resetAllSounds")
	VisualServer.set_default_clear_color(Color.lightskyblue)
	SoundPlayer.play_sound(SoundPlayer.MENU)

func _on_StartButton_pressed():
	get_tree().change_scene("res://Levels/Level1.tscn")
	Events.emit_signal("resetAllSounds")
	
func _on_ControlsButton_pressed():
	get_tree().change_scene("res://GUI/Controls.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
