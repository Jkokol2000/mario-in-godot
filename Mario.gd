extends KinematicBody2D

onready var global_vars = get_node("/root/GlobalVariables")
# Player Variables
export var walk_speed = 60 #Player Walk Speed
export var acceleration = 5 #Player's Accelerating Speed
export var jump_acceleration = -200 #Player's Jump Impulse
export var run_speed = 300 #Player Run Speed
var current_powerup #Current Status of Mario's Powerup
onready var _animated_sprite = $MarioSprites #Mario's Sprites
var can_jump = true #Mario's Ability to jump
var is_running = false # Is Mario Running?
var velocity = Vector2.ZERO #Mario's Velocity
var direction = Vector2.ZERO #Mario's Moving Direction

func _enter_tree():
	current_powerup = "smallMario" # When the game starts, mario's powerup is set to small (so None)

func get_input():
	direction = Vector2.ZERO 
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif is_on_floor():
		_animated_sprite.play(current_powerup + "_Idle")
	if direction.x != 0 and is_on_floor():
		_animated_sprite.play(current_powerup + "_Walking")
		
	if Input.is_action_just_pressed("jump"):
		direction.y -= 1
		_animated_sprite.stop()
		_animated_sprite.play(current_powerup + "_Jump")
	if Input.is_action_just_released("jump"):
		if velocity.y < -50:
			velocity.y = -50
		pass
		_animated_sprite.play(current_powerup + "_Jump")
	if Input.is_action_pressed("run"):
			is_running = true
	if Input.is_action_just_released("run"):
			is_running = false
	return direction


func _process(_delta):
	if current_powerup == "smallMario":
		$MarioHitbox.shape.extents = Vector2(51, 87)
	elif current_powerup == "bigMario":
		$MarioHitbox.shape.extents = Vector2(61, 175)
func _physics_process(delta):
	direction = get_input()
	print(velocity.y)
	if !is_running:
		velocity.x = move_toward(velocity.x, direction.x * walk_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, direction.x * run_speed, acceleration)
	velocity.y += global_vars.fall_speed * delta
	if direction.y < 0 && is_on_floor():
		velocity.y = -500
		
	if direction.x < 0:
		get_node("MarioSprites").set_flip_h(true)
	elif direction.x > 0:
		get_node("MarioSprites").set_flip_h(false)
	if (direction.x < 0 and velocity.x > 0 or direction.x > 0 and velocity.x < 0) and is_running:
		_animated_sprite.play(current_powerup + "_TurnAround")
	velocity = move_and_slide(velocity, Vector2.UP)
	

	


func _on_MushroomPickup_body_entered(body):
	if body.name == "Mario":
		get_parent().get_node("Mushroom").queue_free()
		current_powerup = "bigMario"
		print(current_powerup)
