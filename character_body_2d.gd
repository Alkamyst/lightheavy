extends CharacterBody2D


const MAXSPEED = 300.0
const SPEED = MAXSPEED/15
const FALLING_SPEED = MAXSPEED/15
const JUMP_VELOCITY = -500.0
var gravity = Globals.gravity_medium
var gravity_state = 0
@onready var Sprite: AnimatedSprite2D = $Sprite2D
@onready var HeadSprite: AnimatedSprite2D = $HeadSprite
@onready var PickupArea = $PickupArea
@onready var Walldetection = $WallDetection
var carrying: bool = false

@onready var Gun = $Gun

@onready var PaintSound: AudioStreamPlayer2D = $PaintSound
@onready var JumpSound: AudioStreamPlayer2D = $JumpSound
@onready var PickupSound: AudioStreamPlayer2D = $PickupSound
@onready var WinSound: AudioStreamPlayer2D = $WinSound
@onready var PickupGunSound: AudioStreamPlayer2D = $PickupGunSound
@onready var NuhuhSound: AudioStreamPlayer2D = $NuhuhSound

@export_enum("No", "Yes") var Has_Gun: int

var jump_time = 0

func play_idle():
	Sprite.play("Idle")
	
func play_idle_hold():
	Sprite.play("Idle_Holding")
	
func play_jump():
	Sprite.play("Jump")
	
func play_jump_hold():
	Sprite.play("Jump_Holding")
	
func play_move():
	Sprite.play("Moving")
	
func play_move_hold():
	Sprite.play("Moving_Holding")
	
func _ready() -> void:
	Music.play_music_level()
	if Has_Gun:
		$Gun.visible = true
		
	InputMap.action_set_deadzone("left", 0.4)
	InputMap.action_set_deadzone("right", 0.4)
		
func _physics_process(delta: float) -> void:
	
	if velocity.x < 0:
		Sprite.flip_h = true
		HeadSprite.flip_h = true
		PickupArea.rotation_degrees = 180
		Walldetection.rotation_degrees = 180
		if Gun.get_scale() == Vector2(1, 1):
			Gun.apply_scale(Vector2(-1, 1))
	elif velocity.x > 0:
		Sprite.flip_h = false
		HeadSprite.flip_h = false
		PickupArea.rotation_degrees = 0
		Walldetection.rotation_degrees = 0
		if Gun.get_scale() == Vector2(-1, 1):
			Gun.apply_scale(Vector2(-1, 1))
	
	if jump_time > 0:
		jump_time -= 1
	
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y += gravity * delta
		elif jump_time > 5:
			velocity.y += gravity * 3 * delta
		elif velocity.y > 0:
			velocity.y += gravity * .8 * delta
		else: 
			velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		JumpSound.pitch_scale = randf_range(0.9, 1.1)
		JumpSound.play()
		velocity.y = JUMP_VELOCITY
		jump_time = 15

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if (direction > .1):
		direction = 1
	elif (direction < -.1):
		direction = -1
	if is_on_floor():
		if (velocity.x < 0 and direction > 0) or (velocity.x > 0 and direction < 0): # Turning
			velocity.x *= .5
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAXSPEED, SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED*2)
	# Falling speed
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * MAXSPEED, FALLING_SPEED)
		else:
			velocity.x = move_toward(velocity.x, 0, FALLING_SPEED)
			
	if gravity == Globals.gravity_low:
		HeadSprite.play("Blue")
		gravity_state = 1
	elif gravity == Globals.gravity_high:
		HeadSprite.play("Red")
		velocity.x *= .95
		gravity_state = 2
	else:
		HeadSprite.play("Grey")
		gravity_state = 0

	move_and_slide()
	
	pickup_behavior()
	
	play_animations()
	
	if Input.is_action_just_pressed("reset"):
		reset_room()
	
func reset_room():
	set_process(false)
	set_physics_process(false)
	Sprite.pause()

	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(get_tree().reload_current_scene)
	
	const FADEOUT = preload("res://Objects/Transition/Transition.tscn")
	var fadeout = FADEOUT.instantiate()
	fadeout.Fade = 1
	
	var root = get_tree().get_root()
	
	for element in get_all_children(root):
		if element.is_in_group("level"):
			element.add_child(fadeout)
	
func pickup_behavior():
	
	var pickupOverlap = PickupArea.get_overlapping_areas()
	
	var children = get_children()

	if Input.is_action_just_pressed("pickup") and carrying:
		if is_on_floor():
			if not Walldetection.has_overlapping_bodies():
				for i in children:
					if "drop" in i:
						i.drop(self, Sprite.flip_h)
						carrying = false
						if Has_Gun:
							$Gun.visible = true
						PickupSound.play()
						return
			else:
				for i in children:
					if i.is_in_group("box"):
						i.play_shake()
						NuhuhSound.play()
					
	
	for i in pickupOverlap:
		if i.is_in_group("pickup"):
			if is_on_floor():
				if Input.is_action_just_pressed("pickup") and !carrying:
					i.get_parent().pick_up(self)
					carrying = true
					if Has_Gun:
						$Gun.visible = false
					PickupSound.play()
					return
					
	if Input.is_action_just_pressed("shoot") and Has_Gun and !carrying:
		Gun.shoot(gravity_state)

func play_animations():
	if velocity.y != 0:
		if carrying:
			play_jump_hold()
		else:
			play_jump()
	elif velocity.x != 0:
		if carrying:
			play_move_hold()
		else:
			play_move()
	else:
		if carrying:
			play_idle_hold()
		else:
			play_idle()

func _on_goal_detection_area_entered(area: Area2D) -> void:
	if "goal" in area.get_groups():
		complete_level(area.file_path)
		
func complete_level(next_level_file: String) -> void:
	WinSound.play()
	set_process(false)
	set_physics_process(false)
	Sprite.pause()
	
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
	
	const FADEOUT = preload("res://Objects/Transition/Transition.tscn")
	var fadeout = FADEOUT.instantiate()
	fadeout.Fade = 1
		
	var root = get_tree().get_root()
	
	for element in get_all_children(root):
		if element.is_in_group("level"):
			element.add_child(fadeout)
	
func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
	
