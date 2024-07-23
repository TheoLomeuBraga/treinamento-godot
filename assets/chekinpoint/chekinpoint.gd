extends Area3D

var keep_emiting_timer = 0
func _process(delta):
	$GPUParticles3D.emitting = keep_emiting_timer > 0
	if keep_emiting_timer > 0:
		keep_emiting_timer -= delta

func _on_body_entered(body):
	if body.has_method("set_last_safe_pos"):
		if body.hit_floor:
			body.set_last_safe_pos()
			keep_emiting_timer = 0.5
			$AudioStreamPlayer.play()
