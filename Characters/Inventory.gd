extends Node

class_name Inventory

@export var resources : Dictionary = {}

signal resource_count_changed(type : ResourceItem, new_count : int)

func add_resources(type : ResourceItem, amount : int = 1):
	resources[type] = resources.get(type, 0) + amount
	
	emit_signal("resource_count_changed", type, resources[type])

func _ready():
	pass
