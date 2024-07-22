extends Area3D


func _on_body_entered(body):
	if body.has_method("set_last_safe_pos"):
		if body.hit_floor:
			body.set_last_safe_pos()
