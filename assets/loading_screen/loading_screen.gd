extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	ResourceLoader.load_threaded_request(Global.current_scene_loading)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress := []
	ResourceLoader.load_threaded_get_status(Global.current_scene_loading,progress)
	$ProgressBar.value = progress[0] * 100
	get_tree().change_scene_to_file(Global.current_scene_loading)
