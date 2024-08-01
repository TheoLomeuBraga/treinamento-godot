extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var timer = 0.0
func _process(delta):
	timer += delta
	if timer >= lifetime:
		queue_free()
