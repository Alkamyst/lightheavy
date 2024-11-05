extends CharacterBody2D

@export_enum("Medium", "Low", "High") var init_gravity: int

var grav_medium = Globals.gravity_medium
var grav_high = Globals.gravity_high
var grav_low = Globals.gravity_low

var gravity

@onready var Sprite = $Sprite2D
@onready var Collision = $CollisionShape2D
@onready var CollisionPickedUp = $CollisionShapePickedUp
@onready var PlayerMonitorArea = $PlayerMonitorArea
var picked_up: bool = false
@onready var PaintSound: AudioStreamPlayer2D = $PaintSound
@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer

func play_default():
	AnimPlayer.play("default")
	
func play_shake():
	AnimPlayer.stop()
	AnimPlayer.play("shake")

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
		else:
			velocity.x = 0
			
		if not is_on_ground():
			bounce_away_from_player()
				
		move_and_slide()
			
	if gravity == Globals.gravity_low:
		Sprite.texture = load("res://Sprites/Box/BoxBlue.png")
	elif gravity == Globals.gravity_high:
		Sprite.texture = load("res://Sprites/Box/BoxRed.png")
	else:
		Sprite.texture = load("res://Sprites/Box/Box.png")

func is_on_ground():
	var playerMonitorBodies = PlayerMonitorArea.get_overlapping_bodies()

	for body in playerMonitorBodies:
		if body.is_in_group("ground"):
			return true
	
	return false

func bounce_away_from_player():
	var playerMonitorBodies = PlayerMonitorArea.get_overlapping_bodies()

	for body in playerMonitorBodies:
		if body.is_in_group("player"):
			velocity.y = -100.0
			if global_position.x > body.global_position.x:
				velocity.x = 200
			else:
				velocity.x = -200
		
func change_col_layers(isPickedUp: bool):
	set_collision_layer_value(1, !isPickedUp)
	set_collision_layer_value(5, !isPickedUp)
	set_collision_layer_value(8, isPickedUp)
	
func pick_up(player):
	reparent(player)
	global_position = Vector2(player.global_position.x, player.global_position.y - 48)
	picked_up = true
	Collision.disabled = true
	CollisionPickedUp.disabled = false
	
	change_col_layers(true)
	
func drop(player: CharacterBody2D, faceLeft):
	var root = get_tree().get_root()
	
	# Important! Make sure the level scene has group "level"
	# This makes the box not stay between levels
	reparent(get_tree().current_scene)
	get_tree().current_scene.move_child(self, player.get_index())

	if faceLeft:
		global_position = Vector2(player.global_position.x - 48, player.global_position.y)
	else:
		global_position = Vector2(player.global_position.x + 48, player.global_position.y)
	picked_up = false
	Collision.disabled = false
	CollisionPickedUp.disabled = true
	
	change_col_layers(false)
