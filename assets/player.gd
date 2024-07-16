extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


var jump_power = 1200.0
const GRAVITY = 980.2
var jump_current_power = 0.0

func move(delta):
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("left","right")
	move_input.z = Input.get_axis("foward","back")
	
	if $RayCast3D.is_colliding():
		velocity = $RayCast3D.get_collision_normal().direction_to(move_input.normalized())  * 1200.0 * delta
	else:
		velocity = move_input.normalized() * 1200.0 * delta
	
	var hit_floor = $ShapeCast3Dfloor.is_colliding()
	if hit_floor:
		jump_current_power = 0
		if jump_current_power > 0:
			$ShapeCast3Dceling.enabled = true
		if Input.get_action_strength("jump") > 0.0:
			jump_current_power = jump_power
			$AudioStreamPlayer.play()
	
	var hit_celing = $ShapeCast3Dceling.is_colliding()
	if hit_celing:
		$ShapeCast3Dceling.enabled = false
		jump_current_power = 0
	
	if jump_current_power != 0:
		velocity.y = jump_current_power * delta
	
	move_and_slide()
	
	jump_current_power -= delta * GRAVITY

func make_camera_do_stuf(delta):
	var root = $cameraRoot
	var cam = $Camera3D
	

func _process(delta):
	move(delta)
	make_camera_do_stuf(delta)
	

