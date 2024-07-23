extends Area3D

func _on_body_entered(body):
	print("A")
	if body.has_method("go_last_safe_pos"):
		body.go_last_safe_pos()
		print("B")
