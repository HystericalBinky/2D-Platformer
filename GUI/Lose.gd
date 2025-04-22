extends Control


func _ready():
	VisualServer.set_default_clear_color(Color.lightskyblue)

func _on_QuitButton_pressed():
		get_tree().change_scene("res://GUI/Menu.tscn")
