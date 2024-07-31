@tool
extends CharacterBody3D

@export var idle_in_editor = true

var speed := 300
var turn_speed := 10

enum behavior{
	off = 0,
	idle = 1,
	chase = 2,
}
var behavior_state : behavior = 1

var gunBarrel : Node3D
func _ready():
	if not Engine.is_editor_hint():
		pass
	gunBarrel = $spider_turret/Armature/GeneralSkeleton/Cube/gunBarrel

var projectile_asset = preload("res://assets/projectile/projectile.tscn")

var colldown : float = 0
func shoot():
	if colldown <= 0:
		$spider_turret/AnimationPlayer.play("strong shoot")
		var projectile : Node3D = projectile_asset.instantiate()
	
		get_tree().get_root().add_child(projectile)
		projectile.global_position = gunBarrel.global_position
		projectile.global_rotation = gunBarrel.global_rotation
		projectile.color = Color.RED
		projectile.damage = 2
		projectile.speed = 5
		projectile.range = 100
		colldown = 1
		
		$spider_turret/Armature/GeneralSkeleton/Cube/gunBarrel/AudioStreamPlayer3D.play()

func idle(delta):
	if colldown <= 0:
		$spider_turret/AnimationPlayer.play("idle")
	
	
	shoot()
	colldown -= delta
	if position.distance_to(player_pos) > 10 and colldown <= 0:
		behavior_state = 2
	

func chase(delta):
	$spider_turret/AnimationPlayer.play("walk")
	if position.distance_to(player_pos) < 10:
		behavior_state = 1

var player_pos = null
func _process(delta):
	
	if Engine.is_editor_hint():
		if idle_in_editor:
			$spider_turret/AnimationPlayer.play("idle") 
	else:
		player_pos = Global.variables["player"].position
		if player_pos != null:
			if behavior_state == 0:
				$spider_turret/AnimationPlayer.play("idle") 
			if behavior_state == 1:
				idle(delta)
			elif behavior_state == 2:
				chase(delta)
				

func _physics_process(delta):
	if player_pos != null:
		if behavior_state == 1:
			var direction : Vector3 = (player_pos - global_position).normalized()
			$spider_turret.look_at(global_position+Vector3(-direction.x,0,-direction.z),Vector3.UP)
		elif behavior_state == 2:
			$NavigationAgent3D.target_position = player_pos
			var direction : Vector3 = ($NavigationAgent3D.get_next_path_position() - global_position).normalized()
			velocity = direction * speed * delta
			move_and_slide()
			$spider_turret.look_at(global_position+Vector3(-direction.x,0,-direction.z),Vector3.UP)
		



