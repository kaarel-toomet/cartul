extends KinematicBody2D



var type = 0

var speed = 2

var mousein = false
var health = 5.0
var main

var map_x
var map_y

func _ready():
	main = get_parent().get_parent()



func _process(_delta):
	if get_parent().get_parent().paused: return
	var ppos = get_parent().get_parent().get_node("player").position
	move_and_slide((ppos - position).normalized()*speed*60)
	
	if mousein and Input.is_action_just_pressed("lclick"):
		health -= 1
		#print(health)
	if health <= 0:
		#print("dddddd")
		main.monster_num -= 1
		main.get_node("ui").get_node("ScrollContainer").get_node("hotbar").get_item(main.MONSTER_PART, 1)
		main.mouse_on_monster = false
		queue_free()
	
	map_x = floor(position.x/main.scale.x/main.tile_size.x)
	map_y = floor(position.y/main.scale.y/main.tile_size.y)
	
	
	
	if main.map.get_cell(map_x, map_y) == main.ERROR:
		health -= 0.1



func _on_Area2D_mouse_entered():
	get_parent().get_parent().mouse_on_monster = true
	mousein = true
	#print("kala")


func _on_Area2D_mouse_exited():
	get_parent().get_parent().mouse_on_monster = false
	mousein = false
