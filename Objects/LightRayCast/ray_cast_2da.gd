extends RayCast2D

@onready var parent: RayCast2D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation_degrees = (rotation_degrees + parent.degrees)
	position.x = (position.x - parent.distance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
