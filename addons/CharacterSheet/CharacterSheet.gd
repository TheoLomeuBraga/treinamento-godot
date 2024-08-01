@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("CharacterSheet", "Node", preload("CharacterSheetNode.gd"), preload("CharacterSheet.png"))


func _exit_tree():
	remove_custom_type("CharacterSheet")

