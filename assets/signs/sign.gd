extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global.variables["player"].nearst_signes.find(self) <= 0:
		Global.variables["player"].nearst_signes.push_back(self)

var current_action = 0

var player_pos = null
@export var dialog : Array[String]
func _process(delta):
	player_pos = Global.variables["player"].position
	if Global.variables["player"].nearst_signes.size() > 0 and Global.variables["player"].nearst_signes[0] == self and position.distance_to(player_pos) < 5 and Input.is_action_just_pressed("interact"):
		
		Global.variables["player"].in_conversation = true
		$Label.visible = true
		
		if current_action >= dialog.size():
			Global.variables["player"].in_conversation = false
			current_action = -1
			$Label.visible = false
		
		$Label.text = tr(dialog[current_action])
		current_action += 1
		
	elif position.distance_to(player_pos) > 5:
		current_action = 0
		
	
		
			
