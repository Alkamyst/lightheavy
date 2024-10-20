extends Node2D

@onready var StartSound: AudioStreamPlayer2D = $StartSound
@onready var black = $Black

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	black.modulate.a *= .99
	if Input.is_action_just_pressed("pickup"):
		title_transition()
		
func title_transition():
	StartSound.play()
	set_process(false)
	
	var tween = create_tween()
	tween.tween_interval(1)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Title Screen/title_screen.tscn")
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
