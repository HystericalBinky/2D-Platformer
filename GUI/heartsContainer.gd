extends HBoxContainer

onready var HeartGuiClass = preload("res://GUI/heartGui.tscn")

func _ready():
	Events.connect("healthChanged", self, "_on_Player_healthChanged")

func setMaxHearts(maxHearts: int):
	for i in range(maxHearts):
		var heart = HeartGuiClass.instance()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	
	for i in range(currentHealth):
		hearts[i].updateHeart(true)
		
	for i in range(currentHealth, hearts.size()):
		hearts[i].updateHeart(false)

func _on_Player_healthChanged(currentHealth: int):
	var hearts = get_children()
	
	for i in range(currentHealth):
		hearts[i].updateHeart(true)
		
	for i in range(currentHealth, hearts.size()):
		hearts[i].updateHeart(false)
