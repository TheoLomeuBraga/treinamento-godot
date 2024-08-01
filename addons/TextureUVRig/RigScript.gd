@tool
extends Node


var m : Material
func _ready():
	if expressions_mesh.get_surface_override_material(0) == null:
		expressions_mesh.set_surface_override_material(0,expressions_mesh.mesh.surface_get_material(0).duplicate())
	m = expressions_mesh.get_surface_override_material(0)

@export var expressions_size : int = 1.0

enum axis {
	x=0,
	y=1,
	z=2,
}
@export var rig_axis : axis 

@export var expressions_rig : Node3D
@export var expressions_mesh : MeshInstance3D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if expressions_size > 0 and expressions_rig != null and expressions_mesh != null and m != null:
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
		
		if m != null:
			m.set("uv1_offset",Vector2(0.0,pos))
			expressions_mesh.set_surface_override_material(0,m) 
	#print(expressions_size > 0 , expressions_rig != null , expressions_mesh != null , m != null)
