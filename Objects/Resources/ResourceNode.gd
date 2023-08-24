extends StaticBody2D

class_name ResourceNode


@export var node_types : Array[ResourceNodeType] = []
@export var starting_resources : int = 8
@export var pickup_type : PackedScene
@export var pickup_launch_min_speed : float = 300
@export var pickup_launch_max_speed : float = 400
@export var pickup_launch_min_vertical_angle_deg : float = 90
@export var pickup_launch_max_vertical_angle_deg : float = 90
@export var particle_color : Color = Color(255, 255, 255)
@export var effect_explode: PackedScene
@export var effect_hit: PackedScene

@onready var level_parent = get_parent()

var current_resources : int:
	set(value):
		current_resources = value
		
		if (value <= 0):
			explode()

func _ready():
	current_resources = starting_resources

func harvest(from_direction : Vector2, amount: int):
	var amount_harvested : int = min(amount, current_resources)
	
	print_debug("Harvesting {amount}".format({"amount": amount_harvested}))
	
	for n in amount_harvested:
		# Spawn a resource
		spawn_resource(-1 * from_direction)
		
		# Spawn a hit effect
		if (effect_hit):
			var effect : GPUParticles2D = effect_hit.instantiate() as GPUParticles2D
			
			level_parent.add_child(effect)
			
			effect.modulate = particle_color
			effect.position = position
			effect.rotation = PI + from_direction.angle()
			
		
	
	current_resources -= amount_harvested

func spawn_resource(toward_direction : Vector2):
	var pickup_instance : Pickup = pickup_type.instantiate() as Pickup
	
	level_parent.add_child(pickup_instance)
	
	# Get random speed and angles
	var launch_speed = randf_range(pickup_launch_min_speed, pickup_launch_max_speed)
	var launch_planar_angle = toward_direction.angle() + randf_range(-0.25 * PI, 0.25 * PI)
	var launch_vertical_angle = deg_to_rad(randf_range(pickup_launch_min_vertical_angle_deg, pickup_launch_max_vertical_angle_deg))
	
	# Construct final velocity vector
	var launch_planar_velocity = Vector2(cos(launch_planar_angle), sin(launch_planar_angle)) * launch_speed * cos(launch_vertical_angle)
	var launch_vertical_velocity = launch_speed * sin(launch_vertical_angle)
	var launch_velocity = Vector3(launch_planar_velocity.x, launch_planar_velocity.y, launch_vertical_velocity)
	
	print_debug("Spawning resource at {position} launching at {velocity}".format({"position": position, "velocity": launch_velocity}))
	
	pickup_instance.update_pickup_position(global_position + Vector2(0, -1)) # Put one pixel behind to put it behind ysort
	pickup_instance.launch(launch_velocity)
	
func explode():
	# Spawn a few random pickups
	
	for n in randi_range(1, 2):
		spawn_resource(Vector2.from_angle(randf_range(0, 2 * PI)))
		
	# Spawn particle effect
	
	var effect : GPUParticles2D = effect_explode.instantiate() as GPUParticles2D
	
	
	level_parent.add_child(effect)
	
	effect.modulate = particle_color
	effect.position = position
	
	queue_free();
