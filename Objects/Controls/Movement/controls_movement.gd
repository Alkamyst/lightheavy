extends Node2D

@onready var gamepad = $Gamepad
@onready var keyboard = $Keyboard

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.keyboard_mode:
		keyboard.visible = true
		gamepad.visible = false
	else:
		keyboard.visible = false
		gamepad.visible = true
