extends Area2D

class_name Pickup

@export var resource_type : Resource
@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var attracting_to : AttractionArea = null
var real_pos: Vector2 = Vector2.ZERO
var ground_pos: Vector2 = Vector2.ZERO
var planar_velocity: Vector2 = Vector2.ZERO
var vertical_velocity: float = 0
var in_air: bool = false
var launch_gravity : float = 1000 # This should be something global

func launch(velocity: Vector3):
	in_air = true
	planar_velocity = Vector2(velocity.x, velocity.y * 0.5)
	vertical_velocity = velocity.z
	
func update_pickup_position(new_position : Vector2 = Vector2.ZERO, height : float = 0):
	position = new_position
	ground_pos = new_position
	real_pos = ground_pos + Vector2(0, -1 * max(0, height))

func _enter_tree():
	update_pickup_position(global_position)

func _ready():
	connect("body_entered", _on_body_entered)
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	
	# Wait a brief moment before making this collideable
	
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(0.5).timeout
	collision_shape.set_deferred("disabled", false)
	
func _physics_process(delta):
	# PRE MOVEMENT PHASE
	
	var gravity_acceleration : float = 0
	var attract_acceleration : Vector2 = Vector2.ZERO
	
	if (in_air):	
		# Calculate full gravity acceleration
		
		gravity_acceleration = launch_gravity * delta
	else:
		vertical_velocity = 0
		
	if (attracting_to != null):
		# Calculate full attraction acceleration
		
		var attract_vector = attracting_to.global_position - ground_pos
		var attract_real_distance = (attract_vector * Vector2(1, 2)).length()
		var attract_ratio = 1 - (attract_real_distance / attracting_to.attraction_radius)
		var attract_strength = attracting_to.attraction_strength
		
		attract_acceleration = (attracting_to.global_position - ground_pos).normalized() * attract_strength * delta
		
	# Pre-movement acceleration
	
	vertical_velocity += gravity_acceleration * 0.5
	planar_velocity += attract_acceleration * 0.5
	
	# MOVEMENT PHASE
	
	# Add planar components to the object position as well as the ground position
	
	real_pos += planar_velocity * delta
	ground_pos += planar_velocity * delta
	
	# Add the vertical component to the y direction, which we project z axis onto
	# Use vt + 1/2at^2 for more accurate position
	
	real_pos.y += vertical_velocity * delta
	
	# Check if we hit the ground
	
	if (in_air and real_pos.y >= ground_pos.y):
		# Determine t at which we hit ground (linear estimate)
		
		var walk_back_time : float = (real_pos.y - ground_pos.y) / vertical_velocity
		
		# Walk back ground position to that point
		
		ground_pos -= planar_velocity * walk_back_time
		
		# Set real position to ground position
		
		real_pos = ground_pos
		
		# If vertical velocity is great enough, reverse it and "bounce"
		
		if (vertical_velocity > 20):
			vertical_velocity *= -0.5
			planar_velocity *= 0.5
		else:
			in_air = false
	
	# Put the root node at the ground level for ysorting purposes
	
	position = ground_pos
	
	# Move sprite and collision body to the real position
	# relative to the ground position
	
	sprite.position = real_pos - ground_pos
	collision_shape.position = real_pos - ground_pos
	
	# POST MOVEMENT PHASE

	# Post-movement acceleration
	
	vertical_velocity += gravity_acceleration * 0.5
	planar_velocity += attract_acceleration * 0.5
	
	# Decay movement if on ground and not being attracted
	
	if (!in_air):
		if (planar_velocity.length() < 5):
			planar_velocity = Vector2.ZERO
		elif (attract_acceleration.dot(planar_velocity) <= 0):
			planar_velocity /= 1.2

func _on_body_entered(body : Node2D):
	var inventory : Inventory = body.find_child("Inventory")
	
	if (inventory):
		inventory.add_resources(resource_type, 1)
		queue_free()
		
func _on_area_entered(area: Area2D):
	if (area is AttractionArea):
		attracting_to = area
		
func _on_area_exited(area: Area2D):
	if (area is AttractionArea):
		attracting_to = null
