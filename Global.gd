extends Node

const variables_defout = {"mouse_sensitivity": 12.0,
"joystick_sensitivity": 12.0,
"full_screen": false,
"volume": 0
}

var variables = {"mouse_sensitivity": 12.0,
"joystick_sensitivity": 12.0,
"full_screen": false,
"volume": 0,
"pause": false
}

const config_save_path_folder = "user://my_plataformer_test_game"
const config_save_path = "user://my_plataformer_test_game/config.cfg"
func save_config():
	DirAccess.make_dir_absolute(config_save_path_folder)  
	var file = FileAccess.open(config_save_path,FileAccess.WRITE)
	file.store_var(variables["mouse_sensitivity"])
	file.store_var(variables["joystick_sensitivity"])
	if variables["full_screen"]:
		file.store_var(1)
	else:
		file.store_var(0)
		
	file.store_var(variables["volume"])
	
	print("save",variables)
	
func load_config():
	if FileAccess.file_exists(config_save_path):
		var file = FileAccess.open(config_save_path,FileAccess.READ)
		var mouse_sensitivity = file.get_var()
		var joystick_sensitivity = file.get_var()
		var full_screen  = file.get_var()
		var volume = file.get_var()
		
		if mouse_sensitivity != null and joystick_sensitivity != null and full_screen != null and volume != null:
			variables["mouse_sensitivity"] = mouse_sensitivity
			variables["joystick_sensitivity"] = joystick_sensitivity
			variables["full_screen"] = full_screen
			variables["volume"] = volume
			print("load",variables)
		else:
			print("load error")
			save_config()
	
	else:
		print("config file not exist")
		save_config()
		
