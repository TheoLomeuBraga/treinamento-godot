@tool
extends CharacterBody3D

@export var idle_in_editor = true

var speed := 300
var turn_speed := 10

enum behavior{
	off = 0,
	idle = 1,
	chase = 2,
	pain = 3,
	death = 3
}
var behavior_state : behavior = 0

var gunBarrel : Node3D
func _ready():
	if not Engine.is_editor_hint():
		pass
	gunBarrel = $spider_turret/Armature/GeneralSkeleton/Cube/gunBarrel
	
	

var projectile_asset = preload("res://assets/projectile/projectile.tscn")

var player_pos = null
var colldown : float = 0
func shot():
	if colldown <= 0:
		
		if player_pos.distance_to(position) > 5:
			$spider_turret/AnimationPlayer.play("strong shoot")
			var projectile : Node3D = projectile_asset.instantiate()
	
			get_tree().get_root().add_child(projectile)
		
			projectile.global_position = gunBarrel.global_position
			projectile.global_rotation = gunBarrel.global_rotation
			projectile.color = Color.RED
			projectile.damage = 5
			projectile.speed = 20
			projectile.range = 100
			colldown = 1
		
			if player_pos != null:
				projectile.look_at(player_pos,Vector3.UP)
		
			$spider_turret/Armature/GeneralSkeleton/Cube/gunBarrel/AudioStreamPlayer3D.play()
		else:
			$spider_turret/AnimationPlayer.play("mele atack")
			colldown = 1

func off(delta):
	$spider_turret/AnimationPlayer.play("idle")
	if position.distance_to(player_pos) < 20:
		behavior_state = 2

func idle(delta):
	if colldown <= 0:
		$spider_turret/AnimationPlayer.play("idle")
	
	
	shot()
	colldown -= delta
	if position.distance_to(player_pos) > 20 and colldown <= 0:
		behavior_state = 2
	

func chase(delta):
	$spider_turret/AnimationPlayer.play("walk")
	if position.distance_to(player_pos) < 20:
		behavior_state = 1

@onready var damage_paint_targets : Array[MeshInstance3D] = [
	$spider_turret/Armature/GeneralSkeleton/Cube/Cube,
	$spider_turret/Armature/GeneralSkeleton/Cube_001/Cube_001,
	$spider_turret/Armature/GeneralSkeleton/Cube_013/Cube_013,
	$spider_turret/Armature/GeneralSkeleton/Cube_012/Cube_012,
	$spider_turret/Armature/GeneralSkeleton/Cube_007/Cube_007,
	$spider_turret/Armature/GeneralSkeleton/Cube_006/Cube_006,
	$spider_turret/Armature/GeneralSkeleton/Cube_005/Cube_005,
	$spider_turret/Armature/GeneralSkeleton/Cube_016/Cube_016,
	$spider_turret/Armature/GeneralSkeleton/Cube_015/Cube_015,
	$spider_turret/Armature/GeneralSkeleton/Cube_014/Cube_014,
	$spider_turret/Armature/GeneralSkeleton/Cube_010/Cube_010,
	$spider_turret/Armature/GeneralSkeleton/Cube_009/Cube_009,
	$spider_turret/Armature/GeneralSkeleton/Cube_008/Cube_008,
	$spider_turret/Armature/GeneralSkeleton/base/base,
]
func set_color(color : Color):
	
	for m in damage_paint_targets:
		var mat : Material
		if  m.get_surface_override_material(0) == null:
			mat = m.mesh.surface_get_material(0).duplicate()
		else:
			mat = m.get_surface_override_material(0)
		
		mat.set("albedo_color",color)
		m.set_surface_override_material(0,mat)


func pain(delta):
	$spider_turret/AnimationPlayer.play("damage")
	
	set_color(Color(1,0,0,1))
		
	colldown -= delta
	if colldown <= 0:
		set_color(Color(1,1,1,1))
		behavior_state = 2

@export var explosion_effect : PackedScene
@export var hit_sound : PackedScene
func death(delta):
	if explosion_effect != null:
		var explosion = explosion_effect.instantiate()
		get_tree().get_root().add_child(explosion)
		explosion.global_position = global_position
		explosion.amount = 32
		explosion.lifetime = 2
		explosion.lifetime = 1
		if hit_sound != null:
				explosion.add_child(hit_sound.instantiate())
	queue_free()

func _process(delta):
	
	if Engine.is_editor_hint():
		if idle_in_editor:
			$spider_turret/AnimationPlayer.play("idle") 
	else:
		player_pos = Global.variables["player"].position
		if player_pos != null:
			if behavior_state == 0:
				off(delta)
			if behavior_state == 1:
				idle(delta)
			elif behavior_state == 2:
				chase(delta)
			elif behavior_state == 3:
				pain(delta)
			elif behavior_state == 4:
				death(delta)


var timer_to_next_path_update : float = 0
var next_path_position : Vector3 = Vector3.ZERO

func get_next_path_position(delta) -> Vector3:
	
	timer_to_next_path_update -= delta
	
	if timer_to_next_path_update < 0:
		next_path_position = ($NavigationAgent3D.get_next_path_position() - global_position).normalized()
		timer_to_next_path_update = RandomNumberGenerator.new().randf_range(0.75,1.25)
	
	return next_path_position

func _physics_process(delta):
	if player_pos != null:
		if behavior_state == 1:
			var direction : Vector3 = (player_pos - global_position).normalized()
			$spider_turret.look_at(global_position+Vector3(-direction.x,0,-direction.z),Vector3.UP)
		elif behavior_state == 2:
			$NavigationAgent3D.target_position = player_pos
			var direction : Vector3 = get_next_path_position(delta)
			velocity = direction * speed * delta
			move_and_slide()
			$spider_turret.look_at(global_position+Vector3(-direction.x,0,-direction.z),Vector3.UP)
		





func _on_character_sheet_health_changed(current_health, health_change):
	if health_change < 0:
		behavior_state = 3
		colldown = 0.3


func _on_character_sheet_health_is_over():
	behavior_state = 4
