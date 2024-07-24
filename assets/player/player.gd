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



@export var jump_power = 12.0
@export var gravity = 9.8
@export var speed = 12.0
var jump_current_power = 0.0


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
	

#speed
@export var aim_mode = false
@export var turn_speed = 10.0
func make_display_model_look(movement_direction,camera_direction,delta):
	var display_model = $displayModel
	
	if aim_mode:
		var target_position = display_model.global_transform.origin + camera_direction
		display_model.look_at(target_position, Vector3.UP)
	else:
		if delta >= 0:
			var target_position = display_model.global_transform.origin + movement_direction
			if display_model.global_transform.origin != target_position:
				var direction = (target_position - display_model.global_transform.origin).normalized()
				var target_rotation = display_model.global_transform.basis.get_rotation_quaternion()
				var current_rotation = display_model.global_transform.basis.get_rotation_quaternion()

				var target_look_at = Basis().looking_at(direction, Vector3.UP).get_rotation_quaternion()
				var new_rotation = current_rotation.slerp(target_look_at, turn_speed * delta)

				display_model.global_transform.basis = Basis(new_rotation)
		else:
			display_model.look_at(display_model.global_transform.origin + movement_direction, Vector3.UP)


var jumping = false
var hit_floor = false
var floor_last_direction = Vector3.ZERO
@export var air_ajust_speed = 0.5

func move(delta):
	var move_input := Vector3.ZERO
	move_input.x = Input.get_axis("left","right")
	move_input.z = Input.get_axis("foward","back")
	
	var camera_root = $cameraRootY
	
	var forward_direction = camera_root.global_transform.basis.z.normalized()
	var right_direction = camera_root.global_transform.basis.x.normalized()
	var movement_direction = (forward_direction * move_input.z + right_direction * move_input.x)
	
	hit_floor = $ShapeCast3Dfloor.is_colliding()
	
	var ledge_contact = $displayModel/ledgeRayZ.is_colliding() and $displayModel/ledgeRayZ/ledgeRayY.is_colliding()
	var ledge_ray_y_normal = $displayModel/ledgeRayZ.get_collision_normal()
	
	var velocity_y_last_frame = velocity.y
	
	if hit_floor:
		if $RayCast3D.is_colliding() and movement_direction.x != 0 and movement_direction.z != 0:
			floor_last_direction = $RayCast3D.get_collision_normal().direction_to(movement_direction)
			velocity = floor_last_direction * speed  * 100.0 * delta
		else:
			floor_last_direction = movement_direction
			velocity = floor_last_direction * speed  * 100.0 * delta
	else:
		if jumping:
			
			
			if air_ajust_speed > 0:
				
				floor_last_direction += movement_direction * (air_ajust_speed * delta)
				
				if (abs(floor_last_direction.x) + abs(floor_last_direction.z)) > 1.0:
					floor_last_direction = floor_last_direction
				
				
					
				if $ShapeCast3DWalls.is_colliding():
					var hit_normal = $ShapeCast3DWalls.get_collision_normal(0)
					print(velocity)
					floor_last_direction = floor_last_direction.slide(hit_normal) 
					print(velocity)
					
				velocity = floor_last_direction * speed  * 100.0 * delta
				
			else:
				velocity = floor_last_direction * speed  * 100.0 * delta
		else:
			velocity.x = 0
			velocity.z = 0
		
	
	if hit_floor:
		make_display_model_look(movement_direction,-forward_direction.normalized(),delta)
	
	if ( hit_floor or ledge_contact ) and velocity_y_last_frame <= 0:
		if ledge_contact:
			ledge_ray_y_normal.y = 0
			ledge_ray_y_normal = ledge_ray_y_normal.normalized()
			$displayModel.look_at($displayModel.global_transform.origin - ledge_ray_y_normal,Vector3.UP)
			
		
		jumping = false
		velocity.y = 0
		jump_current_power = 0
		$ShapeCast3Dceling.enabled = true
			
		if Input.is_action_just_pressed("jump") and velocity.y <= 0:
			jumping = true
			jump_current_power = jump_power * 100
			$AudioStreamPlayer.pitch_scale = RandomNumberGenerator.new().randf_range(0.75, 1.25)
			$AudioStreamPlayer.play()
			make_display_model_look(movement_direction,-forward_direction.normalized(),-1)
	
	
	
	
	if $ShapeCast3Dceling.is_colliding():
		$ShapeCast3Dceling.enabled = false
		jump_current_power = 0
	
	if jumping:
		velocity.y = gravity + jump_current_power * delta
	else:
		velocity.y = jump_current_power * delta
		
	
	
	move_and_slide()
	jump_current_power -= delta * (gravity * 100)
	

func move_objects(delta):
	Input.is_action_just_pressed("interact")

func _process(delta):
	if !Global.variables["pause"]:
		look_around(delta)
		var is_grabing_big_box = false
		
		if is_grabing_big_box:
			move_objects(delta)
		else:
			move(delta)
	
	if Input.is_action_just_pressed("pause"):
		pause()
		
	

