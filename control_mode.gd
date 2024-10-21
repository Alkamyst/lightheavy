extends Node

var fullscreen = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("keyboard"):
		Globals.keyboard_mode = true
	elif Input.is_action_just_pressed("gamepad"):
		Globals.keyboard_mode = false
		
	if Input.is_action_just_pressed("fullscreen") && !fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
		fullscreen = true
	elif Input.is_action_just_pressed("fullscreen") && fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 
		fullscreen = false
		
