@tool
extends Button

class_name ItemButton

@export var item : Item :
	set(new_item):
		item = new_item
		icon = item.texture
