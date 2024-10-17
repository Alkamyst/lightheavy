extends CollisionPolygon2D

@onready var RayCastA = %RayCast2DA
@onready var RayCastB = %RayCast2DB

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var polygon: PackedVector2Array = get_polygon()
	polygon.set(1, RayCastA.target_position)
	polygon.set(2, RayCastB.target_position)
	print(polygon[1])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
