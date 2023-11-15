extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var walk_speed = 60
export var acceleration = 5
export var jump_speed = 200
export var jump_acceleration = 100
export var fall_acceleration = 155
export var gravity = 20
export var fall_speed = 100
export var run_speed = 300
var can_jump = true
var is_running = false
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
func get_input():
	direction = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_just_pressed("jump") and can_jump == true:
		direction.y -= 1
		can_jump = false
	if Input.is_action_just_released("jump"):
		if velocity.y < -50:
			velocity.y = -50
	if Input.is_action_pressed("run"):
			is_running = true
	if Input.is_action_just_released("run"):
			is_running = false
	return direction


	

func _physics_process(delta):
	direction = get_input()
	if !is_running:
		velocity.x = move_toward(velocity.x, direction.x * walk_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, direction.x * run_speed, acceleration)
	velocity.y += fall_acceleration * delta
	if direction.y < 0:
		velocity.y = -jump_acceleration
		direction.y = 0
	if velocity.y >= 0 and is_on_floor():
		can_jump = true
	if direction.x < 0:
		get_node("MarioSprites").set_flip_h(true)
	elif direction.x > 0:
		get_node("MarioSprites").set_flip_h(false)
	print(is_running)	
	velocity = move_and_slide(velocity, Vector2.UP)
	

	
