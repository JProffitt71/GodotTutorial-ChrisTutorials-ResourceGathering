extends MarginContainer

@export var item_display_template : PackedScene

@onready var grid : GridContainer = $Panel/Grid

var displays : Array[ResourceItemDisplay] = [] 
var player_inventory : Inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	var player : Player = get_tree().get_first_node_in_group("player")
	
	player_inventory = player.find_child("Inventory") as Inventory
	player_inventory.connect("resource_count_changed", _on_player_inventory_resource_count_changed)
	
	# Hide inventory initially
	
	self.visible = false


func _on_player_inventory_resource_count_changed(type : ResourceItem, new_count : int):
	# Find display item for resource
	
	var current_display : ResourceItemDisplay
	
	for display in displays:
		if (display.resource_type == type):
			current_display = display
			break
	
	# If none exists, create one
	
	if (current_display == null):
		current_display = item_display_template.instantiate()
		current_display.resource_type = type
		grid.add_child(current_display)
		displays.append(current_display)
		
	# Update display item for resource with new count
	
	current_display.update_count(new_count)
	
	# Show inventory now that we have items
	
	self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
