extends Control



	
func compile_shaders() -> void:
	for c in $particleRender.get_children():
		if c is GPUParticles3D or c is CPUParticles3D and c.emitting:
			c.one_shot = true
			c.emitting = true

func are_shaders_compiled() -> bool:
	for c in $particleRender.get_children():
		if c is GPUParticles3D or c is CPUParticles3D:
			if c.emitting:
				return false
	return true

func _ready():
	ResourceLoader.load_threaded_request(Global.current_scene_loading)
	
	compile_shaders()

func _process(delta):
	Global.variables["pause"] = false
	var progress := []
	ResourceLoader.load_threaded_get_status(Global.current_scene_loading,progress)
	$ProgressBar.value = progress[0] * 100
	if progress[0] == 1 and are_shaders_compiled():
		get_tree().change_scene_to_file(Global.current_scene_loading)
	
	
