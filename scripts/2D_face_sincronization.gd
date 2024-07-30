@tool
extends Node3D


var m : Material
func _ready():
	m = expressions_mesh.get_surface_override_material(0)

@export var expressions_size : int = 1.0
@export var expressions_rig : Node3D
@export var expressions_mesh : MeshInstance3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if expressions_size > 0 and expressions_rig != null and expressions_mesh != null and m != null:
		var pos_y = expressions_rig.position.y
		pos_y *= 2
		pos_y = int(pos_y)
		m.set("uv1_offset",Vector2(0.0,((pos_y) / float(expressions_size))))
		expressions_mesh.set_surface_override_material(0,m) 
	#print(expressions_size > 0 , expressions_rig != null , expressions_mesh != null , m != null)
