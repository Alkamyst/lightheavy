extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "Has_Gun" in body:
		body.PickupGunSound.play()
		body.Has_Gun = 1
		if "Gun" in body:
			body.Gun.visible = true
		queue_free()
