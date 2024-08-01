extends Node

class_name  CharacterSheet

@export var health : int = 50
@export var max_health : int = 100

@export var defence_percentage : int = 25

@export var power : int = 50
@export var max_power: int = 100

var invencible : bool = false
var hited : bool = false
var health_change : int = 0
func hit(points):
	if not invencible:
		hited = true
		health_change -= max(0,points-defence_percentage) 
		health -= points
		if health < 0:
			health = 0

func heal(points):
	health_change += points
	health += points
	if health > max_health:
		health = max_health

signal health_changed(current_health,health_change)
signal health_is_over()
signal no_effect()

func _ready():
	pass 

func _process(delta):
	
	
	if health_change != 0:
		if health == 0:
			health_is_over.emit()
		else:
			health_changed.emit(health,health_change)
	elif hited:
		no_effect.emit()
	hited = false
	health_change = 0
	
