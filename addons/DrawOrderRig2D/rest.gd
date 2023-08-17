@tool
extends Node2D
class_name SortDrawOrder2D

@export var order : Array[NodePath] = [] :
	set(value):
		order = []
		draw_index_by_item = {}
		
		# Convert paths to be relative to this node
		
		for item in value:
			var node : Node2D = get_node_or_null(item)
			
			if (null == node):
				order.append(NodePath())
				continue
				
			order.append(self.get_path_to(node, false))
			
		# Map paths to their draw index
		
		var i : int = 0
		
		for item in order:
			draw_index_by_item[item.get_concatenated_names()] = i
			i += 1
		
		self.update_draw_order()
	get:
		print("TEST")
		return order
		
@export var test : Array[Node] = []
		
var draw_index_by_item : Dictionary = {}

func update_draw_order():
	for node in self.get_children():
		var rel_path = self.get_path_to(node)
		var draw_index = draw_index_by_item.get(rel_path.get_concatenated_names(), 0)
			
		RenderingServer.canvas_item_set_draw_index(node.get_canvas_item(), draw_index)
