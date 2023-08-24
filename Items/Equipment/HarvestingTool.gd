extends EquippableItem

class_name HarvestingTool

@export var target_types : Array[ResourceNodeType] = []
@export var min_amount : int = 1
@export var max_amount : int = 1

# Interact with body that this tool hit
func interact_with_body(direction_to_body : Vector2, body):
	# Harvest resource nodes
	
	if (body is ResourceNode):
		_interact_with_resource_node(direction_to_body, body)

# Interact with a resource node that this tool hit
func _interact_with_resource_node(direction_to_node : Vector2, resource_node: ResourceNode):
	for type in target_types:
		if (resource_node.node_types.has(type)):
			print_debug("HarvestingTool hit body {body} (matched type {type})".format({"body": resource_node.name, "type": type.display_name}))
			resource_node.call_deferred("harvest", direction_to_node, randi_range(min_amount, max_amount))
