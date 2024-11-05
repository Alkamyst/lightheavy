extends Sprite2D

#1152
#72

@onready var AnimPlayer: AnimationPlayer = $AnimationPlayer

@export_enum("Fadein", "Fadeout") var Fade: int

var tempScale = get_scale()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Fade == 1:
		AnimPlayer.play("FadeOut")
	else:
		AnimPlayer.play("FadeIn")
		#set_scale(Vector2(-1152, 1152))
		global_position = Vector2(1152, 0)
	#tempScale = get_scale()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#if Fade == 1:
		#tempScale.x = move_toward(tempScale.x, 1152, tempScale.x/20)
		#tempScale.y = move_toward(tempScale.y, 1152, tempScale.y/20)
			
	#else:
		#pass
		#tempScale.x = move_toward(tempScale.x, 1, abs(tempScale.x/20))
		#tempScale.y = move_toward(tempScale.y, 1, tempScale.y/20)
		#if tempScale.x == 1:
			#queue_free()
	#set_scale(tempScale)
