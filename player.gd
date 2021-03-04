extends KinematicBody2D



var speed = 6
#var scale = 2

func _ready():
	pass#speed *= scale.x

func _process(delta):
	if Input.is_action_pressed("up"):
		move_and_slide(Vector2(0,-speed*60))
	if Input.is_action_pressed("down"):
		move_and_slide(Vector2(0,speed*60))
	if Input.is_action_pressed("left"):
		move_and_slide(Vector2(-speed*60,0))
	if Input.is_action_pressed("right"):
		move_and_slide(Vector2(speed*60,0))
	var map_pos = Vector2(floor(position.x/get_parent().scale.x/get_parent().tile_size.x),
	floor(position.y/get_parent().scale.y/get_parent().tile_size.y))
	if get_parent().map.get_cellv(map_pos) == 3:
		speed = 3
	else:
		speed = 6
