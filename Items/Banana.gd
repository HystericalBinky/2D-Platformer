extends Area2D

onready var anim = $AnimatedSprite

func _on_Banana_body_entered(body):
	if body.name == "Player":
		Events.emit_signal("bananaCollected")
		anim.play("Collected")
		SoundPlayer.play_sound(SoundPlayer.COLLECT)

func _on_AnimatedSprite_animation_finished():
	if anim.animation == "Collected":
		queue_free()
