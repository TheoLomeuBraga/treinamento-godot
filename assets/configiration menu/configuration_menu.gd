extends Control

func _ready():
	Global.load_config()
	$TabContainer/controls/mouse_sensitivity.value = Global.variables["mouse_sensitivity"]
	$TabContainer/controls/joystick_sensitivity.value = Global.variables["joystick_sensitivity"]
	$TabContainer/video/full_screen.button_pressed = Global.variables["full_screen"]
	$TabContainer/audio/volume.value = Global.variables["volume"]
	#$TabContainer/language/OptionButton

var redy_next_input = false
func _input(event):
	
	if Input.is_action_just_pressed("ui_tab_right") == false && Input.is_action_just_pressed("ui_tab_left") == false:
		redy_next_input = true
	
	if redy_next_input:
		if Input.is_action_just_pressed("ui_tab_right"):
			$TabContainer.select_next_available()
			redy_next_input = false
			
		if Input.is_action_just_pressed("ui_tab_left"):
			$TabContainer.select_previous_available()
			redy_next_input = false


var next_tab = 0
func _process(delta):
	if next_tab == 0:
		$TabContainer/video/full_screen.grab_focus()
		next_tab = -1
		
	elif next_tab == 1:
		$TabContainer/audio/volume.grab_focus()
		next_tab = -1
		
	elif next_tab == 2:
		$TabContainer/controls/mouse_sensitivity.grab_focus()
		next_tab = -1
	elif next_tab == 3:
		$TabContainer/language/OptionButton.grab_focus()
		next_tab = -1
		
		

func _on_tab_container_tab_selected(tab):
	next_tab = tab

func _on_full_screen_toggled(toggled_on):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Global.variables["full_screen"] = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Global.variables["full_screen"] = false

func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	Global.variables["volume"] = value
	






func _on_mouse_sensitivity_value_changed(value):
	Global.variables["mouse_sensitivity"] = value


func _on_joystick_sensitivity_value_changed(value):
	Global.variables["joystick_sensitivity"] = value



