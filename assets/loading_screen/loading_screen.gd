extends Control


func _ready():
	ResourceLoader.load_threaded_request(Global.current_scene_loading)


func _process(delta):
	Global.variables["pause"] = false
	var progress := []
	ResourceLoader.load_threaded_get_status(Global.current_scene_loading,progress)
	$ProgressBar.value = progress[0] * 100
	if progress[0] == 1:
		get_tree().change_scene_to_file(Global.current_scene_loading)
	
	
