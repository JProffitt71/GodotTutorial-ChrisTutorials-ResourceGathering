extends CharacterBody2D

class_name Player

@export var speed : float = 100.0

@onready var animation_tree : AnimationTree = $AnimationTree

var direction : Vector2 = Vector2.ZERO
var swinging : bool = false

func _ready():
	animation_tree.active = true

func _process(delta):
	update_animation_parameters()

func _physics_process(delta):
	# Skip any movement processing if we're swinging
	
	if swinging:
		return;
	
	# Get the input direction and handle the movement/deceleration.
	
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
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
		
	if (Input.is_action_just_pressed("use")):
		animation_tree["parameters/conditions/swing"] = true
	else:
		animation_tree["parameters/conditions/swing"] = false
		
	if (direction != Vector2.ZERO):
		animation_tree["parameters/Idle/blend_position"] = direction
		animation_tree["parameters/Walk/blend_position"] = direction
		animation_tree["parameters/Swing/blend_position"] = direction


func _on_animation_tree_animation_started(anim_name):
	if anim_name in ["swing_up", "swing_left", "swing_right", "swing_down"]:
		swinging = true


func _on_animation_tree_animation_finished(anim_name):
	if anim_name in ["swing_up", "swing_left", "swing_right", "swing_down"]:
		swinging = false
