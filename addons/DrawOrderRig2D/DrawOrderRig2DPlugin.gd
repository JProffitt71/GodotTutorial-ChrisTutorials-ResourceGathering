@tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("DrawOrderRig2D", "Node2D", preload("DrawOrderRig2D.gd"), null)

func _exit_tree():
	remove_custom_type("DrawOrderRig2D")
