@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("TextureUVRig", "Node", preload("RigScript.gd"), null)


func _exit_tree():
	remove_custom_type("TextureUVRig")

