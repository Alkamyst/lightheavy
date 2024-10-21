extends Area2D

@export_file("*.tscn") var file_path
@export_enum("No", "Yes") var FinalLevel: int

@onready var Sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	if FinalLevel == 1:
		Sprite.play("Final")
