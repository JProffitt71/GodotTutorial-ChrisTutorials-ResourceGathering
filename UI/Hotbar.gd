extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
var hand_equip : HandEquip

@onready var grid_container : GridContainer = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	if (!player):
		return
	
	hand_equip = player.find_child("HandEquip")

	for button in grid_container.get_children():
		if button is ItemButton:
			button.pressed.connect(_on_button_pressed.bind(button))

func _on_button_pressed(button):
	if (button.item is EquippableItem):
		hand_equip.equipped_item = button.item
