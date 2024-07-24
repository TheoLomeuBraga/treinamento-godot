extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(delta):
	if $ShapeCast3D.is_colliding():
		var i = 0
		while true:
			var body = $ShapeCast3D.get_collider(i)
			if body == null:
				break
			else:
				if body.has_method("hit_box"):
					body.hit_box()
					break
		
	
