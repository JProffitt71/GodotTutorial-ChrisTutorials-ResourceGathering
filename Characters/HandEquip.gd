@tool
extends Sprite2D

class_name HandEquip

@export var equipped_item : EquippableItem:
	set(new_equipped_item):
		print("Setting a new equipped item ", new_equipped_item)
		equipped_item = new_equipped_item
		
		if (equipped_item != null):
			self.texture = equipped_item.texture
		else:
			self.texture = null

func _on_area_2d_body_entered(body):
	if (equipped_item.has_method("interact_with_body")):
		equipped_item.interact_with_body(body.position - find_parent("Player").position, body)
