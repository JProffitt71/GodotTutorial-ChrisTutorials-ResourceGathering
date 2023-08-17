extends Area2D

class_name AttractionArea

@export var attraction_radius_mod : float = 1:
	set(new_radius_mod):
		attraction_radius_mod = new_radius_mod
		_update_attraction_radius(new_radius_mod)
@export var attraction_strength : float = 40
		
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var attraction_radius : float = 0

func _ready():
	_update_attraction_radius(attraction_radius_mod)

func _update_attraction_radius(new_radius_mod):
	if (collision_shape == null):
		return
	
	collision_shape.scale = Vector2(1, 0.5) * new_radius_mod
	
	attraction_radius = collision_shape.shape.radius * new_radius_mod
