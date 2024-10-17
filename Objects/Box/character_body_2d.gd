extends CharacterBody2D

@export_enum("Medium", "Low", "High") var init_gravity: int

var grav_medium = Globals.gravity_medium
var grav_high = Globals.gravity_high
var grav_low = Globals.gravity_low

var gravity

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D
@onready var CollisionPickedUp = $CollisionShapePickedUp
var picked_up: bool = false
@onready var PaintSound: AudioStreamPlayer2D = $PaintSound

func _ready() -> void:
	if init_gravity == 0:
		gravity = grav_medium
	elif init_gravity == 1:
		gravity = grav_low
	else:
		gravity = grav_high

func _physics_process(delta: float) -> void:
	
	if not picked_up:
		# Add the gravity.
		if not is_on_floor():
				velocity.y += gravity * delta
				
		move_and_slide()
			
	if gravity == Globals.gravity_low:
		Sprite.texture = load("res://Sprites/Box/BoxBlue.png")
	elif gravity == Globals.gravity_high:
		Sprite.texture = load("res://Sprites/Box/BoxRed.png")
	else:
		Sprite.texture = load("res://Sprites/Box/Box.png")
	
func pick_up(player):
	reparent(player)
	global_position = Vector2(player.global_position.x, player.global_position.y - 48)
	picked_up = true
	Collision.disabled = true
	CollisionPickedUp.disabled = false
	
func drop(player, faceLeft):
	var root = get_tree().get_root()
	
	# Important! Make sure the level scene has group "level"
	# This makes the box not stay between levels
	for element in get_all_children(root):
		if element.is_in_group("level"):
			reparent(element)
	
	if faceLeft:
		global_position = Vector2(player.global_position.x - 48, player.global_position.y)
	else:
		global_position = Vector2(player.global_position.x + 48, player.global_position.y)
	picked_up = false
	Collision.disabled = false
	CollisionPickedUp.disabled = true

	
func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
