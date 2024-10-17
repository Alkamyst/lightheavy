extends Node2D

const LAUNCH_SPEED = 21000
@onready var RigidBody: RigidBody2D = $RigidBody2D
@onready var Parent = get_parent()
@onready var Sprite: Sprite2D = $RigidBody2D/Sprite2D
@onready var Col: Area2D = $RigidBody2D/Area2D

var affect_carrying = 0

var color_string: Color = "#0000FF"
var type: String = "Light"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Applies initial launch speed from dropper
	if Parent != null:
		var direction = Vector2.DOWN.rotated(Parent.rotation)
		RigidBody.apply_central_force(direction * LAUNCH_SPEED)
		
	Sprite.material.set_shader_parameter("color", Color(color_string))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Rotates Sprite to where the paint is going
	if Parent != null:
		Sprite.rotation = RigidBody.linear_velocity.angle() - Parent.rotation 
		Sprite.rotation_degrees += 270
	

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	spawn_particle()
	queue_free()
	if "carrying" in body:
		if body.carrying && affect_carrying:
			return
	
	if "gravity" in body:
		if type == "Light":
			if body.gravity != Globals.gravity_low:
				if "PaintSound" in body:
					body.PaintSound.play()
				body.gravity = Globals.gravity_low
		elif type == "Heavy":
			if body.gravity != Globals.gravity_high:
				if "PaintSound" in body:
					body.PaintSound.play()
				body.gravity = Globals.gravity_high
		else:
			if body.gravity != Globals.gravity_medium:
				if "PaintSound" in body:
					body.PaintSound.play()
				body.gravity = Globals.gravity_medium

func spawn_particle():
	const PARTICLE = preload("res://Objects/Paint/Particle/paint_splash_particle.tscn")
	var new_particle = PARTICLE.instantiate()
	new_particle.global_position = RigidBody.global_position
	new_particle.global_position.y += 4
	new_particle.material.set_shader_parameter("color", Color(color_string))
	new_particle.emitting = true
	get_tree().current_scene.add_child(new_particle)

func _on_timer_timeout() -> void:
	# Enable collision after leaving dropper
	Col.monitorable = true
	Col.monitoring = true
