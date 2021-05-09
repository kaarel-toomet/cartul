extends KinematicBody2D


var paused = false

var speed = 6
#var scale = 2
var spawnpoint = Vector2(0,0)

#var box_ui = preload("res://box_ui.tscn")
#var inventory = preload("")

#var open_override = false

var map_pos

func _ready():
	pass#speed *= scale.x

func _process(delta):
	if paused: return
	if Input.is_action_pressed("up"):
		move_and_slide(Vector2(0,-speed*60))
	if Input.is_action_pressed("down"):
		move_and_slide(Vector2(0,speed*60))
	if Input.is_action_pressed("left"):
		move_and_slide(Vector2(-speed*60,0))
	if Input.is_action_pressed("right"):
		move_and_slide(Vector2(speed*60,0))
	if Input.is_action_just_pressed("K"):
		spawnpoint = position
	if Input.is_action_just_pressed("R"):
		position = spawnpoint
	if Input.is_action_just_pressed("G"):
		if get_parent().map.get_cellv(map_pos) == 6:
			if get_parent().map_id == 0:
				get_parent().set_map(1)
				get_parent().map.set_cellv(map_pos,6)
			elif get_parent().map_id == 1:
				get_parent().set_map(0)
				get_parent().map.set_cellv(map_pos,6)
		elif get_parent().map.get_cellv(map_pos) == 7 and get_parent().map_id != 2:
			get_parent().set_map(2)
		elif get_parent().map_id == 2:
			get_parent().set_map(get_parent().prev_map)
			
		

	
	
	map_pos = Vector2(floor(position.x/get_parent().scale.x/get_parent().tile_size.x),
	floor(position.y/get_parent().scale.y/get_parent().tile_size.y))
	
	get_parent().get_node("ui").get_node("Label").text = "X = " + str(position.x/get_parent().scale.x/get_parent().tile_size.x) + ", Y = " + str(position.y/get_parent().scale.y/get_parent().tile_size.y)
	
	if get_parent().map.get_cellv(map_pos) == 3:
		speed = 3
	else:
		speed = 6
#	if Input.is_action_just_pressed("E") and get_parent().map.get_cellv(map_pos) == 4 and !open_override:
#		get_parent().data_coordinates = get_parent().data_coordinates.duplicate(true)
#		get_parent().tile_data = get_parent().tile_data.duplicate(true)
#		var data_loc = -1 #get_parent().data_coordinates.find([get_parent().map_id, map_pos.x, map_pos.y, 4])
#		for i in range(len(get_parent().data_coordinates)):
#			if get_parent().data_coordinates[i].duplicate(true) == [get_parent().map_id, map_pos.x, map_pos.y, 4].duplicate(true):
#				data_loc = i
#				break
#
#		print(data_loc) 
#		if data_loc == -1:
#			print("Opened a box with no data, created empty data")
#			get_parent().data_coordinates.append([get_parent().map_id, map_pos.x, map_pos.y, 4])
#			get_parent().tile_data.append([[-1,-1,-1,-1,-1],[0,0,0,0,0]])
#		get_parent().pause()
#		var ui = box_ui.instance()
#		ui.rect_scale = scale
#		ui.stack_limit = get_parent().stack_limit
#		ui.max_item_id = get_parent().max_item_id
#		get_parent().get_node("ui").add_child(ui)
#
#		for i in range(len(get_parent().tile_data[data_loc][0])):
#			ui.set_item(i, get_parent().tile_data[data_loc][0][i],get_parent().tile_data[data_loc][1][i])
#
#	open_override = false
	
	
