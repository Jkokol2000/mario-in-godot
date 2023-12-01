extends KinematicBody2D

onready var _animated_sprite = $GoombaSprites
onready var global_vars = get_node("/root/GlobalVariables")
var speed = 20
var velocity = Vector2.ZERO
var direction = Vector2(1,0)
var stomped = false

func _ready():
	_animated_sprite.play("Moving")

func _physics_process(delta):
	velocity.y = global_vars.fall_speed * 12 * delta
	if is_on_floor() and !stomped:
		velocity.x = direction.x * speed
		if $TurnCheck.is_colliding():
			var TurnCollision = $TurnCheck.get_collider()
			if TurnCollision.name == "TileMap":
				direction.x *= -1
				$TurnCheck.cast_to = -$TurnCheck.cast_to
	elif stomped:
		velocity = Vector2.ZERO
	velocity = move_and_slide(velocity, Vector2.UP)





func _on_StompArea_body_entered(body):
	if body.name == 'Mario':
		_animated_sprite.play("Stomped")
		stomped = true
		$DeathTimer.start()



func _on_DeathTimer_timeout():
	queue_free() # Replace with function body.
