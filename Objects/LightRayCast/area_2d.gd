extends Area2D

@onready var RayCastA = %RayCast2DA
@onready var RayCastB = %RayCast2DB
@onready var Collision = $CollisionPolygon2D
@onready var Visual = $Polygon2D
@onready var Parent = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var polygon: PackedVector2Array = Collision.get_polygon()
	var colPointA = Parent.to_local(RayCastA.get_collision_point())
	var colPointB = Parent.to_local(RayCastB.get_collision_point())
	
	polygon.set(0, RayCastA.position)
	polygon.set(3, RayCastB.position)
	polygon.set(1, colPointA)
	polygon.set(2, colPointB)
	Collision.set_polygon(polygon)
	Visual.set_polygon(polygon)
	
