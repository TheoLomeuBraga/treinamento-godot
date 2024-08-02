@tool
extends Node

@export var expressions_rig_path : NodePath
@export var expressions_mesh_path : NodePath

var expressions_rig : Node3D
var expressions_mesh : MeshInstance3D



func _ready():
	expressions_rig = get_node(expressions_rig_path)
	expressions_mesh = get_node(expressions_mesh_path)

@export var expressions_size : int = 1.0

enum axis {
	x=0,
	y=1,
	z=2,
}
@export var rig_axis : axis 





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if expressions_size > 0 and expressions_rig != null and expressions_mesh != null:
		var pos : float
		if rig_axis == 0:
			pos = float(int(expressions_rig.position.x))
		elif rig_axis == 1:
			pos = float(int(expressions_rig.position.y))
		elif rig_axis == 2:
			pos = float(int(expressions_rig.position.z))
		
		
		var step_size = 1.0 / expressions_size
		pos *= step_size
		pos -= step_size
		
		
		var mat : Material
		mat = expressions_mesh.mesh.surface_get_material(0).duplicate()
			
		
		mat.set("uv1_offset",Vector2(0.0,pos))
		expressions_mesh.set_surface_override_material(0,mat) 
		
		if not Engine.is_editor_hint():
			print(mat.get("uv1_offset"))

