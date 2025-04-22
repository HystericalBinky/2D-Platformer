extends Control

export var BananaCount = 0

func _ready():
	Events.connect("bananaCollected", self, "_bananaCollected")

func _bananaCollected():
	BananaCount += 1
	$Label.text = str(BananaCount) + "/5"
	if BananaCount == 5:
		Events.emit_signal("allBananasCollected")
