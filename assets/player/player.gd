extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


@export var jump_power = 12.0
@export var gravity = 9.8
var jump_current_power = 0.0

@export var mouse_sensitivity = 12.0
@export var joystick_sensitivity = 12.0

var mouse_movement = Vector2.ZERO
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = -event.relative * mouse_sensitivity
		mouse_movement.x = mouse_movement.x
	else:
		mouse_movement = Vector2.ZERO
	

var camera_movement = Vector2.ZERO
func look_around(delta):
	var rootY = $cameraRootY
	var rootX = $cameraRootY/cameraRootX
	
	var joystick_movement = Vector2.ZERO
	joystick_movement.x = Input.get_axis("look_left","look_right") * joystick_sensitivity
	joystick_movement.y = Input.get_axis("look_up","look_down") * joystick_sensitivity
	
	var rot_degres = Vector2.ZERO
	rot_degres.x = rad_to_deg(rootX.rotation.x)
	rot_degres.y = rad_to_deg(rootY.rotation.y)
	
	camera_movement += (mouse_movement / 100) + (joystick_movement)
	
	rot_degres.x = camera_movement.y
	rot_degres.y = camera_movement.x 
	
	if rot_degres.x < -75:
		rot_degres.x = -75
	if rot_degres.x > 75:
		rot_degres.x = 75
		
	rootX.rotation.x = deg_to_rad(rot_degres.x)
	rootY.rotation.y = deg_to_rad(rot_degres.y)
	

@export var aim_mode = false
func make_display_model_look(movement_direction,camera_direction):
	var display_model = $displayModel
	
	if aim_mode:
		var target_position = display_model.global_transform.origin + camera_direction
		display_model.look_at(target_position, Vector3.UP)
	else:
		var target_position = display_model.global_transform.origin + movement_direction
		display_model.look_at(target_position, Vector3.UP)
	

func move(delta):
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("left","right")
	move_input.z = Input.get_axis("foward","back")
	
	var camera_root = $cameraRootY
	
	var forward_direction = camera_root.global_transform.basis.z.normalized()
	var right_direction = camera_root.global_transform.basis.x.normalized()
	var movement_direction = (forward_direction * move_input.z + right_direction * move_input.x).normalized()

	var normalized_direction = movement_direction.normalized()
	if $RayCast3D.is_colliding():
		velocity = $RayCast3D.get_collision_normal().direction_to(normalized_direction)  * 1200.0 * delta
	else:
		velocity = normalized_direction * 1200.0 * delta
	
	make_display_model_look(movement_direction,-forward_direction.normalized())
	
	var hit_floor = $ShapeCast3Dfloor.is_colliding()
	if hit_floor:
		jump_current_power = 0
		$ShapeCast3Dceling.enabled = true
			
		if Input.get_action_strength("jump") > 0.0:
			jump_current_power = jump_power * 100
			$AudioStreamPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(0.75, 1.25)
			$AudioStreamPlayer.play()
	
	
	if $ShapeCast3Dceling.is_colliding():
		$ShapeCast3Dceling.enabled = false
		jump_current_power = 0
	
	if jump_current_power != 0:
		velocity.y = jump_current_power * delta
		
	move_and_slide()
	
	jump_current_power -= delta * (gravity * 100)
	
	

func _process(delta):
	look_around(delta)
	move(delta)
	
	

