@tool
extends Node3D

@export var texture : Texture
@export var color : Color
@export var size : float = 5.0
@export var damage : int = 20.0
@export var speed : float = 1.0
@export var range : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var travel_time : float = 0
@export var explosion_effect : PackedScene
@export var hit_sound : PackedScene

func _physics_process(delta):
	
	

	$Sprite3D.texture = texture
	$Sprite3D.modulate = color
	
	
	$RayCast3D.scale.x = size
	$RayCast3D.scale.y = size
	$RayCast3D.scale.z = size
	
	if not Engine.is_editor_hint():
		$RayCast3D.position.z = -(delta * speed)
		$RayCast3D.target_position.y = -(delta * speed)
		travel_time += delta * speed
		position += global_transform.basis.z.normalized() * -(delta * speed)
		
	if $RayCast3D.is_colliding() or travel_time >= range:
		var collider = $RayCast3D.get_collider()
		if collider != null:
			for c in collider.get_children():
				if c is CharacterSheet:
					c.hit(damage)
					if explosion_effect != null:
						var explosion = explosion_effect.instantiate()
						get_tree().get_root().add_child(explosion)
						explosion.global_position = global_position
						explosion.amount = 4
						explosion.lifetime = 1
						if hit_sound != null:
							explosion.add_child(hit_sound.instantiate())
			
		queue_free()
