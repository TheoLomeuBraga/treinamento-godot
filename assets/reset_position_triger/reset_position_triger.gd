extends Area3D

func _on_body_entered(body):
	if body.has_method("go_last_safe_pos"):
		body.go_last_safe_pos()
