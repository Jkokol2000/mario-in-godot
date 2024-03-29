extends KinematicBody2D
onready var global_vars = get_node("/root/GlobalVariables")
var speed = 20
var velocity = Vector2.ZERO
var direction = Vector2(1,0)
var currentPowerUp = null
var Mario 

func _ready():
	if get_parent().get_node("Mario").current_powerup != null:
		Mario = get_parent().get_node("Mario")
		if Mario.current_powerup == "smallMario":
			currentPowerUp = "Mushroom"
		else:
			currentPowerUp = "Flower"
	else:
		print("Can't Find Mario")
	print(currentPowerUp)


func _physics_process(delta):
	velocity.y = global_vars.fall_speed * 12 * delta
	if is_on_floor():
		velocity.x = direction.x * speed
		if $TurnCheck.is_colliding():
			var TurnCollision = $TurnCheck.get_collider()
			if TurnCollision.name == "TileMap":
				direction.x *= -1
				$TurnCheck.cast_to = -$TurnCheck.cast_to
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_PowerUpPickup_body_entered(body):
	if body.name == "Mario":
		get_parent().get_node("Mario").current_powerup = "bigMario"
		queue_free()
