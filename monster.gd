extends KinematicBody2D



var type = 0

var speed = 3

var mousein = false
var health = 5.0
var main

var map_pos

func _ready():
	main = get_parent().get_parent()



func _process(delta):
	if get_parent().get_parent().paused: return
	var ppos = get_parent().get_parent().get_node("player").position
	move_and_slide((ppos - position).normalized()*speed*60)
	
	if mousein and Input.is_action_just_pressed("lclick"):
		health -= 1
		#print(health)
	if health <= 0:
		#print("dddddd")
		main.monster_num -= 1
		main.get_node("ui").get_node("ScrollContainer").get_node("hotbar").get_item(
			main.MONSTERPART, 1
		)
		queue_free()
	
	map_pos = Vector2(floor(position.x/main.scale.x/main.tile_size.x),
	floor(position.y/main.scale.y/main.tile_size.y))
	
	if main.map.get_cellv(map_pos) == main.ERROR:
		health -= 0.1



func _on_Area2D_mouse_entered():
	get_parent().get_parent().mouse_on_monster = true
	mousein = true


func _on_Area2D_mouse_exited():
	get_parent().get_parent().mouse_on_monster = false
	mousein = false
