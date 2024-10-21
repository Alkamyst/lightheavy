extends Node2D

@onready var black = $Black
@onready var cursor = $Buttons/Cursor
@onready var start = $Buttons/StartBack/Start
@onready var credits = $Buttons/CreditsBack/Credits
@onready var quit = $Buttons/QuitBack/Quit
@onready var startBack = $Buttons/StartBack
@onready var creditsBack = $Buttons/CreditsBack
@onready var quitBack = $Buttons/QuitBack
@onready var animation_player: AnimationPlayer = $Buttons/Cursor/AnimationPlayer
@export var x_position: int

var button_selected = 0

@onready var ClickSound: AudioStreamPlayer2D = $ClickSound
@onready var StartSound: AudioStreamPlayer2D = $StartSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Music.play_title_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cursor.position.x = x_position
	black.modulate.a *= .99
	if button_selected == 0:
		cursor.position.y = startBack.position.y
		start.texture = load("res://Sprites/Title Screen/StartSelected.png")
		credits.texture = load("res://Sprites/Title Screen/Credits.png")
		if Input.is_action_just_pressed("down"):
			ClickSound.play()
			animation_player.stop()
			animation_player.play("new_animation")
			button_selected = 1
		elif Input.is_action_just_pressed("confirm"):
			start_game()
			
	elif button_selected == 1:
		cursor.position.y = creditsBack.position.y
		start.texture = load("res://Sprites/Title Screen/Start.png")
		quit.texture = load("res://Sprites/Title Screen/Quit.png")
		credits.texture = load("res://Sprites/Title Screen/CreditsSelected.png")
		if Input.is_action_just_pressed("up"):
			ClickSound.play()
			animation_player.stop()
			animation_player.play("new_animation")
			button_selected = 0
		elif Input.is_action_just_pressed("down"):
			ClickSound.play()
			animation_player.stop()
			animation_player.play("new_animation")
			button_selected = 2
		elif Input.is_action_just_pressed("confirm"):
			credits_transition()
			
	elif button_selected == 2:
		cursor.position.y = quitBack.position.y
		credits.texture = load("res://Sprites/Title Screen/Credits.png")
		quit.texture = load("res://Sprites/Title Screen/QuitSelected.png")
		if Input.is_action_just_pressed("up"):
			ClickSound.play()
			animation_player.stop()
			animation_player.play("new_animation")
			button_selected = 1
		elif Input.is_action_just_pressed("confirm"):
			get_tree().quit() 
			
func start_game():
	StartSound.play()
	set_process(false)
	
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Levels/level.tscn")
	)
	
	const FADEOUT = preload("res://Objects/Transition/Transition.tscn")
	var fadeout = FADEOUT.instantiate()
	fadeout.Fade = 1
		
	var root = get_tree().get_root()
	
	for element in get_all_children(root):
		if element.is_in_group("level"):
			element.add_child(fadeout)
			
func credits_transition():
	StartSound.play()
	set_process(false)
	
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Title Screen/credits_screen.tscn")
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
	
