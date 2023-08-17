extends HBoxContainer

class_name ResourceItemDisplay

@onready var texture_rect : TextureRect = $TextureRect
@onready var label : Label = $Label

var resource_type : ResourceItem:
	set(new_type):
		resource_type = new_type
		if (texture_rect):
			texture_rect.texture = resource_type.texture

func _ready():
	if (resource_type):
		texture_rect.texture = resource_type.texture

func update_count(count : int):
	label.text = str(count)
