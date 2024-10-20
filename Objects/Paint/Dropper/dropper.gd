extends Node2D

@export_enum("Normal", "Light", "Heavy") var Type: int
@export_enum("Yes", "No") var Affect_Carrying: int

var white = "#777777"
var red = "#FF0000"
var blue = "#0000FF"

@onready var Sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Type == 1:
		Sprite.texture = load("res://Sprites/Dropper/DropperBlue.png")
	elif Type == 2:
		Sprite.texture = load("res://Sprites/Dropper/DropperRed.png")
	else:
		Sprite.texture = load("res://Sprites/Dropper/DropperGrey.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	# Spawns Paint
	const PAINT = preload("res://Objects/Paint/Paint/paint.tscn")
	var new_paint = PAINT.instantiate()
	new_paint.affect_carrying = Affect_Carrying
	new_paint.start_rotation = rotation
	new_paint.parent_rotation = rotation
	if Type == 1:
		new_paint.color_string = blue
		new_paint.type = 'Light'
	elif Type == 2:
		new_paint.color_string = red
		new_paint.type = 'Heavy'
	else:
		new_paint.color_string = white
		new_paint.type = 'Normal'
	
	add_child(new_paint)
