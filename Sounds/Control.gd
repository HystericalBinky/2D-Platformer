extends Control

onready var label = $Label
onready var timer = $Timer

func _ready():
	timer.start()
	Events.connect("resetTimer", self, "_resetTimer")
	
func time_left_to_live():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute, second]

func _process(delta):
	label.text = "%02d:%02d" % time_left_to_live()

func _on_Timer_timeout():
	Events.emit_signal("timer_end")

func _resetTimer():
	timer.stop()
	timer.wait_time = 120
	timer.start()
