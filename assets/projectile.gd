extends Node3D

@export var texture : Texture
@export var color : Color
@export var size : float = 5.0
@export var damage : float = 1.0
@export var speed : float = 1.0
@export var range : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var travel_time : float = 0
func _process(delta):
	$Sprite3D.texture = texture
	$Sprite3D.modulate = color
	$RayCast3D.position.z = delta
	$RayCast3D.target_position.y = delta
	
	$RayCast3D.scale.x = size
	$RayCast3D.scale.y = size
	$RayCast3D.scale.z = size
	
	travel_time += delta * speed
	position -= global_transform.basis.z.normalized() * delta * speed
	
	
	if $RayCast3D.is_colliding() or travel_time >= range:
		queue_free()
