@tool
extends Node2D
class_name DrawOrderRig2D

@export var order : int = 0:
	set(value):
		order = value
		RenderingServer.canvas_item_set_draw_index(self.get_canvas_item(), order)
