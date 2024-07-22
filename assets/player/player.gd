extends CharacterBody3D


func pause():
	Global.variables["pause"] = !Global.variables["pause"]
	if Global.variables["pause"]:
		add_child(load("res://assets/pause menu/pause_menu.tscn").instantiate())
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	elif has_node("PauseMenu"):
		remove_child($PauseMenu)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

var last_safe_position = Vector3.ZERO

func go_last_safe_pos():
	position = last_safe_position
	
func set_last_safe_pos():
	last_safe_position = position

func _ready():
	remove_child($PauseMenu)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_last_safe_pos()

@export var wall_jump_power = 12.0
@export var wall_jumps_per_jump = 1
var wall_jumps_remaining = 1
@export var jump_power = 12.0
@export var gravity = 9.8
@export var speed = 12.0
var jump_current_power = 0.0

@export var air_reduction_speed = 100.0
var extra_air_speed = Vector3.ZERO
func process_air_speed(delta):
	if extra_air_speed.length() > 0:
		var reduction = air_reduction_speed * delta
		if extra_air_speed.length() <= reduction:
			extra_air_speed = Vector3.ZERO
		else:
			extra_air_speed -= extra_air_speed.normalized() * reduction

var mouse_movement = Vector2.ZERO
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = -event.relative * Global.variables["mouse_sensitivity"]
		mouse_movement.x = mouse_movement.x
	else:
		mouse_movement = Vector2.ZERO
	

var camera_movement = Vector2.ZERO
func look_around(delta):
	var rootY = $cameraRootY
	var rootX = $cameraRootY/cameraRootX
	
	var joystick_movement = Vector2.ZERO
	joystick_movement.x = -Input.get_axis("look_left","look_right") * Global.variables["joystick_sensitivity"]
	joystick_movement.y = -Input.get_axis("look_up","look_down") * Global.variables["joystick_sensitivity"]
	
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
		if display_model.global_transform.origin != target_position:
			display_model.look_at(target_position, Vector3.UP)


var jumping = false
func move(delta):
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("left","right")
	move_input.z = Input.get_axis("foward","back")
	
	var camera_root = $cameraRootY
	
	var forward_direction = camera_root.global_transform.basis.z.normalized()
	var right_direction = camera_root.global_transform.basis.x.normalized()
	var movement_direction = (forward_direction * move_input.z + right_direction * move_input.x)
	
	if $RayCast3D.is_colliding() and movement_direction.x != 0 and movement_direction.z != 0:
		velocity = $RayCast3D.get_collision_normal().direction_to(movement_direction) * speed  * 100.0 * delta
	else:
		velocity = movement_direction * 1200.0 * delta
	
	make_display_model_look(movement_direction,-forward_direction.normalized())
	
	var hit_floor = $ShapeCast3Dfloor.is_colliding()
	if hit_floor and jump_current_power <= 0:
		jumping = false
		extra_air_speed = Vector3.ZERO
		velocity.y = 0
		jump_current_power = 0
		wall_jumps_remaining = wall_jumps_per_jump
		$ShapeCast3Dceling.enabled = true
			
		if Input.is_action_just_pressed("jump") and velocity.y <= 0:
			jumping = true
			jump_current_power = jump_power * 100
			$AudioStreamPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(0.75, 1.25)
			$AudioStreamPlayer.play()
	
	
	var wall_raycast = $displayModel/wallRaycast
	if !hit_floor and Input.is_action_just_pressed("jump") and wall_raycast.is_colliding() and wall_jumps_remaining > 0:
		wall_jumps_remaining -= 1
		jumping = true
		jump_current_power = jump_power * 100
		$AudioStreamPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(0.75, 1.25)
		$AudioStreamPlayer.play()
		
		var negative_normal = forward_direction.normalized()
		extra_air_speed.x += negative_normal.x * 40
		extra_air_speed.z += negative_normal.z * 40

	
	if $ShapeCast3Dceling.is_colliding():
		$ShapeCast3Dceling.enabled = false
		jump_current_power = 0
		
		
	
	if jumping:
		velocity.y = gravity + jump_current_power * delta
	else:
		velocity.y = jump_current_power * delta
	
		
		
		
	print(velocity.y)
	velocity += extra_air_speed
	
	
	move_and_slide()
	
	process_air_speed(delta)
	jump_current_power -= delta * (gravity * 100)
	
	

func _process(delta):
	if !Global.variables["pause"]:
		look_around(delta)
		move(delta)
	
	if Input.is_action_just_pressed("pause"):
		pause()
		
	

