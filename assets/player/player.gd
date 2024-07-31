extends CharacterBody3D

var pause_menu_asset = preload("res://assets/pause menu/pause_menu.tscn")

@export var player_input_on := true

func pause():
	Global.variables["pause"] = !Global.variables["pause"]
	if Global.variables["pause"]:
		add_child(pause_menu_asset.instantiate())
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
	Global.variables["player"] = self






var mouse_movement = Vector2.ZERO
func _input(event):
	if event is InputEventMouseMotion:
		mouse_movement = -event.relative * Global.variables["mouse_sensitivity"]
		mouse_movement.x = mouse_movement.x
	else:
		mouse_movement = Vector2.ZERO
	


func look_around(delta):
	
	var rootY = $cameraRootY
	var rootX = $cameraRootY/cameraRootX
	
	var joystick_movement = Vector2.ZERO
	joystick_movement.x = -Input.get_axis("look_left","look_right") * Global.variables["joystick_sensitivity"]
	joystick_movement.y = -Input.get_axis("look_up","look_down") * Global.variables["joystick_sensitivity"]
	
	var rot_degres = Vector2.ZERO
	rot_degres.x = rad_to_deg(rootX.rotation.x)
	rot_degres.y = rad_to_deg(rootY.rotation.y)
	
	var camera_movement : Vector2 = (mouse_movement / 100) + (joystick_movement)
	
	rot_degres.x += camera_movement.y
	rot_degres.y += camera_movement.x 
	
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
var hit_floor_last_frame = true
var hit_floor = false
var floor_last_direction = Vector3.ZERO
@export var air_ajust_speed = 0.25
@export var jump_power = 0.5
@export var gravity = 9.8
@export var speed = 8.0
@export var run_speed = 12.0
var is_runing := false
var jump_current_power = 0.0

var move_input := Vector3.ZERO

var nok_back_time = 0.0
var nok_back_power_direction = Vector3.LEFT * 1000

func move(delta):
	if player_input_on and nok_back_time <= 0:
		move_input.x = Input.get_axis("left","right")
		move_input.z = Input.get_axis("foward","back")
	
	var camera_root = $cameraRootY
	var forward_direction = camera_root.global_transform.basis.z.normalized()
	var right_direction = camera_root.global_transform.basis.x.normalized()
	var movement_direction = (forward_direction * move_input.z + right_direction * move_input.x)
	
	hit_floor = $ShapeCast3Dfloor.is_colliding() or $RayCast3D.is_colliding()
	
	var ledge_contact = $displayModel/ledgeRayZ.is_colliding() and $displayModel/ledgeRayZ/ledgeRayY.is_colliding() and nok_back_time <= 0
	var ledge_ray_y_normal = $displayModel/ledgeRayZ.get_collision_normal()
	
	var velocity_y_last_frame = velocity.y
	
	
	
	if hit_floor:
		if $RayCast3D.is_colliding() and movement_direction.x != 0 and movement_direction.z != 0:
			floor_last_direction = $RayCast3D.get_collision_normal().direction_to(movement_direction)
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
					floor_last_direction = floor_last_direction.slide(hit_normal) 
				
				
					
				velocity = floor_last_direction * speed  * 100.0 * delta
				
			else:
				velocity = floor_last_direction * speed  * 100.0 * delta
		else:
			velocity.x = 0
			velocity.z = 0
			
		if nok_back_time > 0:
			velocity += nok_back_power_direction * delta
	
	if is_runing:
		velocity += -forward_direction * 100.0  * run_speed * delta
	$displayModel/runDust.emitting = is_runing
	
	if hit_floor:
		if Input.is_action_just_pressed("run") and player_input_on and nok_back_time <= 0:
			is_runing = !is_runing
		if not is_runing:
			make_display_model_look(movement_direction,-forward_direction.normalized(),delta)
		else:
			make_display_model_look(-forward_direction,-forward_direction.normalized(),delta)
	elif is_runing:
		make_display_model_look(-forward_direction,-forward_direction.normalized(),delta)
	
	if ( hit_floor or ledge_contact ) and velocity_y_last_frame <= 0:
		if ledge_contact:
			ledge_ray_y_normal.y = 0
			ledge_ray_y_normal = ledge_ray_y_normal.normalized()
			$displayModel.look_at($displayModel.global_transform.origin - ledge_ray_y_normal,Vector3.UP)
			
		
		jumping = false
		velocity.y = 0
		jump_current_power = 0
		$ShapeCast3Dceling.enabled = true
			
		if player_input_on and nok_back_time <= 0 and Input.is_action_just_pressed("jump") and velocity.y <= 0:
			jumping = true
			jump_current_power = jump_power * 100
			$jumpAudio.pitch_scale = RandomNumberGenerator.new().randf_range(0.75, 1.25)
			$jumpAudio.play()
			make_display_model_look(movement_direction,-forward_direction.normalized(),-1)
			
			if ledge_contact:
				floor_last_direction = movement_direction
				velocity = floor_last_direction * speed  * 100.0 * delta
	
	
	if is_runing and $displayModel/wallHitCheker.is_colliding():
		is_runing = false
	
	if $ShapeCast3Dceling.is_colliding():
		$ShapeCast3Dceling.enabled = false
		jump_current_power = 0
	
	if jumping:
		velocity.y = gravity + jump_current_power * delta
	else:
		velocity.y = jump_current_power * delta
		
	
	#stick to the floor when falling
	if hit_floor == true and hit_floor_last_frame == false:
		position.y -= 0.2
		$groundInpact.emitting = true
	
	move_and_slide()
	jump_current_power -= delta * (gravity * 100)
	hit_floor_last_frame = hit_floor
	
	
	if nok_back_time > 0:
		if hit_floor:
			nok_back_time -= delta
	else:
		nok_back_time = 0

var projectile_asset = preload("res://assets/projectile/projectile.tscn")



enum shot_types {
	semi_automatic = 0,
	automatic = 1,
	
}
@export var shot_type : shot_types = shot_types.semi_automatic

@export var fire_rate : float = 0.1
var timer_next_shor : float = 0.1

@export var shot_color : Color = Color.WHITE
@export var shot_damage : float = 1
@export var shoot_speed  : float = 100
@export var shoot_range  : float = 100
@export var shoot_palets : int = 1
@export var shoot_inaccuracy : float = 0.5



func shot(delta):
	
	var shot_input : bool = false
	if shot_type == 0:
		shot_input = Input.is_action_just_pressed("shot")
		aim_mode = hit_floor and timer_next_shor <= 0 and shot_input
	elif shot_type == 1:
		shot_input = Input.get_action_strength("shot") > 0
		aim_mode =  shot_input
	
	if hit_floor and timer_next_shor <= 0 and shot_input:
		timer_next_shor = fire_rate
		
		
		$shootAudio.pitch_scale = RandomNumberGenerator.new().randf_range(0.5, 1.0)
		$shootAudio.play()
		
		var i := 0
		while i < shoot_palets:
			var projectile : Node3D = projectile_asset.instantiate()
			get_tree().get_root().add_child(projectile)
			projectile.global_position = $cameraRootY/cameraRootX/gunBarrel.global_position
			projectile.global_rotation = $cameraRootY/cameraRootX/gunBarrel.global_rotation
		
			var inaccuracy := Vector3.ZERO
			var random := RandomNumberGenerator.new()
			random.randomize()
			var half_shoot_inaccuracy = shoot_inaccuracy / 2.0
			inaccuracy.x = random.randi_range(-half_shoot_inaccuracy, half_shoot_inaccuracy)
			inaccuracy.y = random.randi_range(-half_shoot_inaccuracy, half_shoot_inaccuracy)
			
			
			if $cameraRootY/cameraRootX/SpringArm3D/Camera3D/aimRay.is_colliding():
				projectile.look_at($cameraRootY/cameraRootX/SpringArm3D/Camera3D/aimRay.get_collision_point(),Vector3.UP)

				
			projectile.rotation_degrees += inaccuracy
		
			projectile.color = shot_color
			projectile.damage = shot_damage
			projectile.speed = shoot_speed
			projectile.range = shoot_range
			i+=1
	
		
	timer_next_shor -= delta

func _process(delta):
	if !Global.variables["pause"]:
		
		move(delta)
		if player_input_on:
			look_around(delta)
			shot(delta)
		
	
	if Input.is_action_just_pressed("pause"):
		pause()
		
	

