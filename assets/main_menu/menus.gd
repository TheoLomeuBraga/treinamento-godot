extends Control




func main_menu_on(on):
	$main_menu.set_process(on)
	$main_menu.visible = on
	
func start_menu_on(on):
	$start_menu.set_process(on)
	$start_menu.visible = on
	

@export var menu_type = 0
func select_menu_type():
	if menu_type == 0:
		main_menu_on(true)
		start_menu_on(false)
		$main_menu/play.grab_focus()
	elif menu_type == 1:
		main_menu_on(false)
		start_menu_on(true)
		$start_menu/continue_.grab_focus()
	elif menu_type == 2:
		main_menu_on(false)
		start_menu_on(false)
		$start_menu/continue_.grab_focus()
	

func _ready():
	menu_type = 0
	select_menu_type()

func _on_play_pressed():
	menu_type = 1
	select_menu_type()

func _on_continue__pressed():
	pass

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://testes cenas/city level.tscn")

func _on_configurations_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()



