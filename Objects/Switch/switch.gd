extends StaticBody2D

@onready var WeightDetection = $WeightDetection
@onready var SnapPoint = $SnapPoint
var turnOn: bool = false

var initial_scale

@onready var PressSound: AudioStreamPlayer2D = $PressSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_scale = get_scale()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if turnOn:
		pressed()
	else:
		unpressed()
		
	check_overlap()
				
func check_overlap():
	var weightOverlap = WeightDetection.get_overlapping_bodies()
	
	for i in weightOverlap:
		if "gravity" in i && i.gravity == Globals.gravity_high:
			turnOn = true
			return
		else:
			turnOn = false
	
func pressed():
	set_scale(Vector2(initial_scale.x, initial_scale.y / 2))
	
func unpressed():
	set_scale(Vector2(initial_scale.x, initial_scale.y))


func _on_weight_detection_body_entered(body: Node2D) -> void:
	if "gravity" in body && body.gravity == Globals.gravity_high && !turnOn:
		var weightOverlap = WeightDetection.get_overlapping_bodies()
		
		for i in weightOverlap:
			if "gravity" in i && i.gravity == Globals.gravity_high:
				if "picked_up" in i: # Prevents a FLY AWAY TO VICTORY bug if the player picks up the box while on the switch
					if i.picked_up:
						return
				body.global_position.y = SnapPoint.global_position.y
				turnOn = true
				PressSound.play()
	
	
func _on_weight_detection_body_exited(body: Node2D) -> void:
	if "gravity" in body && body.gravity == Globals.gravity_high && turnOn:
		var weightOverlap = WeightDetection.get_overlapping_bodies()
		
		for i in weightOverlap:
			if "gravity" in i && i.gravity == Globals.gravity_high:
				return
		turnOn = false
		PressSound.play()
