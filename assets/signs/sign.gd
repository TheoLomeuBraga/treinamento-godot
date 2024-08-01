extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var player_pos = null
func _process(delta):
	player_pos = Global.variables["player"].position
