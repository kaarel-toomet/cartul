extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scale = Vector2(2,2)
var tile_size = Vector2(16,16)
var chunk_size = Vector2(16,16)
var gen_dist = Vector2(1,1)

var paused = false

var max_item_id = 5
var stack_limit = 2147483647

var normal_breakto = {-1:-1, 0:2, 1:2, 2:3, 3:-1, 4:2, 5:-1, 6:2}
var player_breakto = {-1:-1, 0:5, 1:5, 2:5, 3:5, 4:5, 5:-1, 6:2}
var breakto = normal_breakto

var normal_player_pos = Vector2()
var internal_player_pos = Vector2()

"""Tile ids
-1: none, 0: asdfstone, 1: grass, 2:sand, 3:water, 4: box, 5: frame, 6: hole
"""

var prev_map = 0
#var tile_data = []
#var data_coordinates = []
## format: 
#tile_data = [[[items],[amounts]]] for boxes
#data_coordinates = [[map, x, y, type]] for all
#example:
#tile_data = [[[0,1,2,3,4,5],[5,4,3,2,1,65535]]] 
#data_coordinates = [[0, 10, 10, 4]]
var seed_ = 0

var player = preload("res://player.tscn")

var earth = preload("res://earth.tscn")
var earth_underg = preload("res://earth_underground.tscn")
var player_map = preload("res://player_map.tscn")

var map
var map_id = 0
var map_scene_to_id = {0:earth, 1:earth_underg, 2:player_map}
var string_map_ids = {0:"earth",1:"earth_underground",2:"player_map"}

func set_map(new_map):
	
	#print("2ewrtyuio")
	prev_map = map_id
	if new_map == 2:
		
		breakto = player_breakto
		normal_player_pos = $player.position
		$player.position = internal_player_pos
	elif prev_map == 2:
		breakto = normal_breakto
		internal_player_pos = $player.position
		$player.position = normal_player_pos
	else:
		breakto = normal_breakto
		normal_player_pos = $player.position
		#$player.position = normal_player_pos
		
	save_current_map()
	if map_id == 2: sync_player_map()
	map_id = new_map
	map.queue_free()
	map = map_scene_to_id[new_map].instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	load_map()
	map.fix_invalid_tiles()

func set_map_no_load(new_map):
	if new_map == 2:
		breakto = player_breakto
	else:
		breakto = normal_breakto
	#save_current_map()
	map_id = new_map
	map.queue_free()
	map = map_scene_to_id[new_map].instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	map.fix_invalid_tiles()









func _ready():
	
	
	
	$ui.stack_limit = stack_limit
	$ui/ScrollContainer/hotbar.stack_limit = stack_limit
	$ui.max_item_id = max_item_id
	$ui/ScrollContainer/hotbar.max_item_id = max_item_id
	$ui/ScrollContainer/hotbar.rect_scale = scale
	$ui/held_item.rect_scale = scale
	
	map = earth.instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	
	var hullmyts = player.instance()
	hullmyts.scale = scale
	add_child(hullmyts)
	
	load_world()
	seed(seed_)
	map.fix_invalid_tiles()






func _process(delta):
	if paused: return
	if Input.is_action_just_pressed("pause"):
		pause()
		var pause_menu = load("res://pause_menu.tscn").instance()
		add_child(pause_menu)
	#$ui/held_item.position = get_global_mouse_position()# + get_viewport_rect().size*0.5
	#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
	var mpos = get_global_mouse_position()
	var mx = floor(mpos.x/tile_size.x/scale.x)
	var my = floor(mpos.y/tile_size.y/scale.y)
	if Input.is_action_just_pressed("lclick") and get_viewport().get_mouse_position().y > 48:
		#print("b")
		#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
		#if map.get_cell(mx,my) == -1: return
		if $ui/ScrollContainer/hotbar.get_item(map.get_cell(mx,my), 1):
			#print("sssssssssssssssssss")
			
#			if map.get_cell(mx,my) == 4:
#				if data_coordinates.find([map_id, mx, my, 4]) == -1:
#					print("Box with no data broken")
#				else:
#					var data = tile_data[data_coordinates.find([map_id, mx, my, 4])]
#					tile_data.remove(data_coordinates.find([map_id, mx, my, 4]))
#					data_coordinates.remove(data_coordinates.find([map_id, mx, my, 4]))
#					for i in range(len(data[0])):
#						$ui/hotbar.get_item(data[0][i], data[1][i])
			map.set_cell(mx,my,breakto[map.get_cell(mx,my)])
			
	if Input.is_action_just_pressed("rclick") and get_viewport().get_mouse_position().y > 48:
#		print(data_coordinates)
#		print(tile_data)
		#print(map.get_cell(mx,my))
		var s = $ui/ScrollContainer/hotbar.selected
		var b = $ui/ScrollContainer/hotbar.tiles[s]
		
		if b != -1 and map.get_cell(mx,my) == breakto[b]:
			$ui/ScrollContainer/hotbar.set_item(s,b,$ui/ScrollContainer/hotbar.amounts[s]-1)
			map.set_cell(mx,my,b)
#			if b == 4:
#				tile_data.append([[-1,-1,-1,-1,-1],[0,0,0,0,0]])
#				data_coordinates.append([map_id, mx, my, 4])
		#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
	
#	if Input.is_action_just_pressed("E"):
#		pause()
#		add_child(load("res://player_editor.tscn").instance())
	
	if Input.is_action_just_pressed("J"):
		if map_id == 0:
			set_map(2)
		elif map_id == 1:
			set_map(2)
		elif map_id == 2:
			set_map(prev_map)
	var pcx = floor($player.position.x/(tile_size.x*chunk_size.x*scale.x))
	var pcy = floor($player.position.y/(tile_size.y*chunk_size.y*scale.y))
	for cx in range(pcx-gen_dist.x,pcx+gen_dist.x+1):
		for cy in range(pcy-gen_dist.y,pcy+gen_dist.y+1):
			if map.get_node("generated").get_cell(cx,cy) == -1:
				map.generate(cx,cy)
				map.get_node("generated").set_cell(cx,cy,0)
				
				







func save_current_map():
	
	var d = Directory.new()
	if not d.dir_exists("res://world"):
		print("world directory doesn't exist, creating...")
		d.make_dir("res://world")
	#print("qqqqqqsdfgh")
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.WRITE)
	#print("aqqqq")
	for chunk in map.get_node("generated").get_used_cells():
		chunks.store_64(chunk.x)
		chunks.store_64(chunk.y)
		for x in range(chunk_size.x):
			for y in range(chunk_size.y):
				chunks.store_16(map.get_cell(x+chunk.x*chunk_size.x, y+chunk.y*chunk_size.y))
	chunks.close()
	var data := File.new()
	data.open("res://world/data",File.WRITE)
	#$player.position.x=-999
	data.store_16($ui/ScrollContainer/hotbar.slot_num)
	for s in range($ui/ScrollContainer/hotbar.slot_num):
		
		data.store_16($ui/ScrollContainer/hotbar.tiles[s])
		#$player.position.x=300*s
		data.store_16($ui/ScrollContainer/hotbar.amounts[s])
	#$player.position.x=999
	data.store_64(seed_)
	data.store_double($player.spawnpoint.x)
	data.store_double($player.spawnpoint.y)
	data.store_double(normal_player_pos.x)
	data.store_double(normal_player_pos.y)
	data.store_double(internal_player_pos.x)
	data.store_double(internal_player_pos.y)
	data.store_16(map_id)
	data.store_16(prev_map)
	data.close()
	
#	var tiledata := File.new()
#	tiledata.open("res://world/tile_data_" + string_map_ids[map_id], File.WRITE)
#	#tiledata.store_16(map_id)
#	#if !len(data_coordinates) == 0:
#	#print(data_coordinates)
#	#print(tile_data)
#	var i = 0
#	while i < (len(data_coordinates)):
#		tiledata.store_64(data_coordinates[i][1])
#		tiledata.store_64(data_coordinates[i][2])
#		tiledata.store_16(data_coordinates[i][3])
#		for j in range(len(tile_data[i][0])):
#			tiledata.store_16(tile_data[i][0][j])
#			tiledata.store_16(tile_data[i][1][j])
#		i += 1
#	tiledata.close()
		

	
	
func load_world():
	
	var data := File.new()
	data.open("res://world/data",File.READ)
	if data.file_exists("res://world/data"):
		for s in range(data.get_16() - 4):
			$ui/ScrollContainer/hotbar.add_slot()
		for s in range($ui/ScrollContainer/hotbar.slot_num):
			$ui/ScrollContainer/hotbar.set_item(s,data.get_16(),data.get_16())
		seed_ = data.get_64()
		$player.spawnpoint.x = data.get_double()
		$player.spawnpoint.y = data.get_double()
		#$player.position.x = data.get_double()
		#$player.position.y = data.get_double()
		normal_player_pos = Vector2(data.get_double(),data.get_double())
		internal_player_pos = Vector2(data.get_double(),data.get_double())
		set_map_no_load(data.get_16())
		if map_id == 2:
			$player.position = internal_player_pos
		else:
			$player.position = normal_player_pos
		prev_map = data.get_16()
	else:
		print("data file not found")
	data.close()
	
	
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/map_" + string_map_ids[map_id]):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_64()
			chunk.y = chunks.get_64()
			map.get_node("generated").set_cellv(chunk,0)
			for x in range(chunk_size.x):
				for y in range(chunk_size.y):
					map.set_cell(x+chunk.x*chunk_size.x,y+chunk.y*chunk_size.x,chunks.get_16())
		chunks.close()
		
	else:
		print("chunks file not found")
		
	sync_player_map()
	
	
#	data_coordinates = []
#	tile_data = []
#
#	var tiledata := File.new()
#	
#	tiledata.open("res://world/tile_data_" + string_map_ids[map_id], File.READ)
#
#	if tiledata.file_exists("res://world/tile_data_" + string_map_ids[map_id]):
#		#tiledata.store_16(map_id)
#		var i = 0
#		while tiledata.get_position() < tiledata.get_len():
#			data_coordinates.append([])
#			data_coordinates[i].append(map_id)
#			data_coordinates[i].append(tiledata.get_64())
#			data_coordinates[i].append(tiledata.get_64())
#			data_coordinates[i].append(tiledata.get_16())
#			tile_data.append([])
#			tile_data[i].append([])
#			tile_data[i].append([])
#			for j in range(5):
#				tile_data[i][0].append(tiledata.get_16())
#				tile_data[i][1].append(tiledata.get_16())
#				if tile_data[i][0][j] == 65535: tile_data[i][0][j] = -1
#			i += 1
#	else:
#		print("tile data file not found")
#	tiledata.close()
		
		
		
		
		
func load_map():
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/map_" + string_map_ids[map_id]):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_64()
			chunk.y = chunks.get_64()
			map.get_node("generated").set_cellv(chunk,0)
			for x in range(chunk_size.x):
				for y in range(chunk_size.y):
					map.set_cell(x+chunk.x*chunk_size.x,y+chunk.y*chunk_size.x,chunks.get_16())
		chunks.close()
		
	else:
		print("chunks file not found")
	
	
	
	#print(data_coordinates)
	#print(tile_data)
#	data_coordinates = []
#	tile_data = []
#	var tiledata := File.new()
#	
#	tiledata.open("res://world/tile_data_" + string_map_ids[map_id], File.READ)
#
#
#	if tiledata.file_exists("res://world/tile_data_" + string_map_ids[map_id]):
#		#tiledata.store_16(map_id)
#		var i = 0
#		while tiledata.get_position() < tiledata.get_len():
#			data_coordinates.append([])
#			data_coordinates[i].append(map_id)
#			data_coordinates[i].append(tiledata.get_64())
#			data_coordinates[i].append(tiledata.get_64())
#			data_coordinates[i].append(tiledata.get_16())
#			tile_data.append([])
#			tile_data[i].append([])
#			tile_data[i].append([])
#			for j in range(5):
#				tile_data[i][0].append(tiledata.get_16())
#				tile_data[i][1].append(tiledata.get_16())
#				if tile_data[i][0][j] == 65535: tile_data[i][0][j] = -1
#			i += 1
#	else:
#		print("tile data file not found")
#	tiledata.close()
	

func sync_player_map():
	
	var chunks := File.new()
	chunks.open("res://world/map_player_map",File.READ)
	
	if chunks.file_exists("res://world/map_player_map"):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_64()
			chunk.y = chunks.get_64()
			#map.get_node("generated").set_cellv(chunk,0)
			for x in range(chunk_size.x):
				for y in range(chunk_size.y):
					$player.get_node("TileMap").set_cell(x+chunk.x*chunk_size.x,y+chunk.y*chunk_size.x,chunks.get_16())
		chunks.close()
		
	else:
		print("player map file not found")

	
	
	
	
	
func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		save_current_map()

func unpause():
	paused = false
	$ui.paused = false
	$player.paused = false
	#map.paused = false

func pause():
	paused = true
	$ui.paused = true
	$player.paused = true
	#map.paused = true

