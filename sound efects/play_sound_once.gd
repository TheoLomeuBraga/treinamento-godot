extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing == false:
		queue_free()
