extends Node2D

var white = "#777777"
var red = "#FF0000"
var blue = "#0000FF"

@onready var ShootSound: AudioStreamPlayer2D = $Pistol/ShootSound

func shoot(Type = 0):
	const BULLET = preload("res://Objects/Paint/Paint/paint.tscn")
	var new_bullet = BULLET.instantiate()
	#new_bullet.global_position = $Pistol/ShootingPoint.global_position
	if get_scale() == Vector2(1, 1):
		new_bullet.start_rotation = deg_to_rad(-90)
	else:
		new_bullet.start_rotation = deg_to_rad(90)
		
	new_bullet.col_rotation = new_bullet.start_rotation
	new_bullet.parent_rotation = rotation
	new_bullet.global_position = $Pistol/ShootingPoint.global_position
	new_bullet.show_behind_parent = false
	new_bullet.enable_col_on_start = true
	
	if Type == 1:
		new_bullet.color_string = blue
		new_bullet.type = 'Light'
	elif Type == 2:
		new_bullet.color_string = red
		new_bullet.type = 'Heavy'
	else:
		new_bullet.color_string = white
		new_bullet.type = 'Normal'
	get_tree().current_scene.add_child(new_bullet)
	
	ShootSound.play()
