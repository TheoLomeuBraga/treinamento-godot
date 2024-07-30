@tool
extends CharacterBody3D

@export var idle_in_editor = true

func _ready():
	if not Engine.is_editor_hint():
		pass

func _process(delta):
	if Engine.is_editor_hint():
		if idle_in_editor:
			$spider_turret/AnimationPlayer.play("idle") 
	else:
		if idle_in_editor:
			$spider_turret/AnimationPlayer.play("idle") 





