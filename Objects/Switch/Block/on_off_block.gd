extends StaticBody2D

@onready var Sprite = $AnimatedSprite2D
@onready var Col = $CollisionShape2D
@onready var BSC = $BoxStuckCheck
var switch
@export_enum("In", "Out") var Start_State: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root = get_tree().get_root()
	
	for element in get_all_children(root):
		if element.is_in_group("switch"):
			switch = element


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if switch.turnOn:
		if Start_State == 0:
			blockOut()
		else: 
			blockIn()
	else:
		if Start_State == 0:
			blockIn()
		else: 
			blockOut()

func blockIn():
	Sprite.play("In")
	Col.disabled = true

func blockOut():
	Sprite.play("Out")
	Col.disabled = false
	var BSC_Overlap = BSC.get_overlapping_bodies()
	
	for i in BSC_Overlap:
		if i.is_in_group("box") and "picked_up" in i:
			if !i.picked_up:
				i.global_position.y -= 4
	
func get_all_children(in_node, array := []):
	array.push_back(in_node)
	for child in in_node.get_children():
		array = get_all_children(child, array)
	return array
