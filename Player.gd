extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

export(Resource) var moveData

var velocity = Vector2.ZERO
var state = MOVE

export var maxHealth = 3

onready var currentHealth: int = maxHealth

onready var ladderCheck = $LadderCheck
onready var remoteTransform2D = $RemoteTransform2D

# MUSIC
const PLAINS = preload("res://Music/Plains.mp3")

# SOUND EFFECTS
const STEP = preload("res://Sounds/Step_Grass.mp3")
const JUMP = preload("res://Sounds/Jump.wav")
const LAND = preload("res://Sounds/Landing.wav")
const LOSE = preload("res://Sounds/Lose.wav")

func _ready():
	Events.connect("timer_end", self, "_timer_end")

func _physics_process(delta):
	
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state: 
		MOVE: move_state(input)
		CLIMB: climb_state(input)

func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	apply_gravity()
	if input.x == 0:
		SoundPlayer.stop_walking_sound()
		apply_friction()
		if is_on_floor():
			$AnimatedSprite.play("Idle")
			$AnimatedSprite.rotation_degrees = 0
			$AnimatedSprite.position.x = 0
	else:
		apply_acceleration(input.x)
		if is_on_floor():
			$AnimatedSprite.play("Run")
			$AnimatedSprite.rotation_degrees = 0
			$AnimatedSprite.position.x = 0
			SoundPlayer.play_walking_sound(STEP)
		
		$AnimatedSprite.flip_h = input.x < 0
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.position.x = 0
		
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.JUMP_FORCE
			SoundPlayer.stop_walking_sound()
	else:
		$AnimatedSprite.play("Jump")
		$AnimatedSprite.rotation_degrees = 0
		$AnimatedSprite.position.x = 0
		if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
			velocity.y = moveData.JUMP_RELEASE_FORCE
		if velocity.y > 0:
			SoundPlayer.stop_walking_sound()
			velocity.y += moveData.FALL_GRAVITY
			$AnimatedSprite.play("Fall")
			$AnimatedSprite.rotation_degrees = 0
			$AnimatedSprite.position.x = 0
			if is_on_floor():
				SoundPlayer.play_sound(LAND)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor() and $AnimatedSprite.animation == "Fall":
				SoundPlayer.play_sound(LAND)

func climb_state(input):
	if not is_on_ladder():
		state = MOVE
	if input.length() != 0:
		$AnimatedSprite.play("Run")
		if $AnimatedSprite.flip_h == false:
			$AnimatedSprite.rotation_degrees = -90
			$AnimatedSprite.position.x = -9
		elif $AnimatedSprite.flip_h == true:
			$AnimatedSprite.rotation_degrees = 90
			$AnimatedSprite.position.x = 9
	else:
		$AnimatedSprite.play("Idle")
		if $AnimatedSprite.flip_h == false:
			$AnimatedSprite.rotation_degrees = -90
			$AnimatedSprite.position.x = -9
		elif $AnimatedSprite.flip_h == true:
			$AnimatedSprite.rotation_degrees = 90
			$AnimatedSprite.position.x = 9
	velocity = input * 50
	velocity = move_and_slide(velocity, Vector2.UP)

func player_hit():
	currentHealth -= 1
	Events.emit_signal("healthChanged", currentHealth)
	if currentHealth == 0:
		SoundPlayer.play_sound(SoundPlayer.LOSE)
		queue_free()
		Events.emit_signal("player_died")

func _timer_end():
	SoundPlayer.play_sound(SoundPlayer.LOSE)
	queue_free()
	Events.emit_signal("player_died")

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func apply_gravity():
		velocity.y += moveData.GRAVITY
		velocity.y = min(velocity.y, 300)
		
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)
