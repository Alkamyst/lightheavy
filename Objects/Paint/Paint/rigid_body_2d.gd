extends RigidBody2D

const LAUNCH_SPEED = 1200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	apply_central_force(direction * LAUNCH_SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
