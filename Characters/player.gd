extends CharacterBody2D


@export var speed : float = 200.0

@onready var animation_tree : AnimationTree = $AnimationTree

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	
	var direction : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	
	if direction:
		velocity = direction * speed
	else:
		# Slow down to zero
		#velocity /= (1 + 10 * delta)
		
		#if (velocity.x + velocity.y) < 10:
			#velocity = Vector2.ZERO
		
		velocity = Vector2.ZERO
		
	move_and_slide()

func update_animation_parameters():
	if (velocity == Vector2.ZERO):
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
	else:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
