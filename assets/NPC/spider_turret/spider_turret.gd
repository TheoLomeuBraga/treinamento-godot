@tool
extends CharacterBody3D

func _ready():
	pass

func _process(delta):
	if Engine.is_editor_hint():
		$spider_turret/AnimationPlayer.play("idle") 
	else:
		pass





