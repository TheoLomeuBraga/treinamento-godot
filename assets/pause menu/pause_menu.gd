extends Control

func _ready():
	$pause_menu/continue_.grab_focus()

func configuration_menu_on(on):
	if on:
		add_child(load("res://assets/configiration menu/configuration_menu.tscn").instantiate())
	elif has_node("configuration_menu"):
		Global.save_config()
		remove_child($configuration_menu)

func pause_menu_on(on):
	$pause_menu.set_process(on)
	$pause_menu.visible = on

var menu_type = 0
func select_menu_type():
	if menu_type == 0:
		pause_menu_on(true)
		configuration_menu_on(false)
		$pause_menu/continue_.grab_focus()
	elif menu_type == 1:
		pause_menu_on(false)
		configuration_menu_on(true)

func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://assets/main_menu/main_menu.tscn")


func _on_configurations_pressed():
	menu_type = 1
	select_menu_type()



func _on_exit_pressed():
	get_tree().quit()
	
func _process(delta):
	if Input.get_action_strength("ui_cancel") > 0.0:
		menu_type = 0
		select_menu_type()


func _on_continue__pressed():
	get_parent().pause()
