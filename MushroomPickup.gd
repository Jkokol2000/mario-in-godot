extends Area2D


func _ready():
	if is_inside_tree():
		connect("body_entered", get_node_or_null("/Mario"), '_on_MushroomPickup_body_entered')
