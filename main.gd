extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scale = Vector2(2,2)
var tile_size = Vector2(16,16)
var chunk_size = Vector2(16,16)
var gen_dist = Vector2(1,1)

var paused = false


var mouse_on_monster = false


var max_item_id = 30
var stack_limit = 2147483647

var normal_breakto = {-1:-1, 0:2, 1:2, 2:3, 3:-1, 4:2, 5:-1, 6:2, 7:-1, 8:2, 9:2,
					  10:2, 11:0,  12:-1, 13:2, 14:-1, 15:-1, 16:-1, 17:-1, 18:-1,
					  19:-1, 20:-1, 21:-1, 22:-1, 23:-1, 24:-1, 25:-1, 26:-1, 27:-1,
					  28:-1, 29:-1, 30:-1}
var player_breakto = {-1:-1, 0:5, 1:5, 2:5, 3:5,  4:5, 5:-1, 6:2, 7:-1, 8:5, 9:5,
					  10:5, 11:10, 12:5,  13:5, 14:5, 15:5, 16:5, 17:5, 18:5,
					  19:5, 20:5, 21:5, 22:5, 23:5, 24:5, 25:24, 26:5, 27:5, 28:5,
					  29:5, 30:5}
var breakto = normal_breakto


#var monsters = []
#format: [ [type, map, x, y, health, extra1, extra2, extra3, extra4] ]
var monster_num = 0
var monster_max = 100


const NONE = -1
const ASDF = 0
const GRASS = 1
const SAND = 2
const WATER = 3
const BOX = 4
const FRAME = 5
const HOLE = 6
const EDITOR = 7
const STAIRS = 8
const BAUXITE = 9
const ALUMINIUM = 10
const BEETROOT = 11
const CRAFTER = 12
const GOLD = 13
const ACTIVE_FURNACE = 14
const INACTIVE_FURNACE = 15
const MERCURY = 16
const PALLADIUM = 17
const MONSTER_PART = 18
const ERROR = 19
const POTATO = 20
const ROTATOR_CCW = 21
const ROTATOR_CW = 22
const RAW_MONSTER_BRICK = 23
const MONSTER_BRICK = 24
const STOVE = 25
const KNIFE = 26
const POTATO_PEELS = 27
const PEELED_POTATO = 28
const BOILED_POTATO = 29
const POT = 30



var names = {
	-1:"tile_none",
	0:"tile_stone",
	1:"tile_grass",
	2:"tile_sand",
	3:"tile_water",
	4:"tile_box",
	5:"tile_frame",
	6:"tile_hole",
	7:"tile_editor",
	8:"tile_stairs",
	9:"tile_bauxite",
	10:"tile_aluminium",
	11:"tile_beetroot",
	12:"tile_assembler",
	13:"tile_gold",
	14:"tile_active_furnace",
	15:"tile_inactive_furnace",
	16:"tile_mercury",
	17:"tile_palladium",
	18:"tile_monster_part",
	19:"tile_error",
	20:"tile_potato",
	21:"tile_rotator_ccw",
	22:"tile_rotator_cw",
	23:"tile_raw_monster_brick",
	24:"tile_monster_brick",
	25:"tile_stove",
	26:"tile_knife",
	27:"tile_potato_peels",
	28:"tile_peeled_potato",
	29:"tile_boiled_potato",
	30:"tile_pot"
}

var textures = [preload("res://assets/asdf.png"), preload("res://assets/grass.png"),
				preload("res://assets/sand.png"), preload("res://assets/water.png"),
				preload("res://assets/box.png"), preload("res://assets/frame.png"),
				preload("res://assets/hole.png"), preload("res://assets/editor.png"),
				preload("res://assets/stairs.png"), preload("res://assets/bauxite.png"),
				preload("res://assets/aluminium.png"), preload("res://assets/beetroot.png"),
				preload("res://assets/machine.png"),preload("res://assets/gold_block.png"),
				preload("res://assets/furnace.png"), preload("res://assets/inactive_furnace.png"),
				preload("res://assets/mercury.png"), preload("res://assets/palladium.png"),
				preload("res://assets/monster_part.png"), preload("res://assets/error.png"),
				preload("res://assets/potato.png"), preload("res://assets/rotator_ccw.png"),
				preload("res://assets/rotator_cw.png"), preload("res://assets/raw_monster_brick.png"),
				preload("res://assets/monster_brick.png"), preload("res://assets/stove.png"),
				preload("res://assets/knife.png"), preload("res://assets/potato_peels.png"),
				preload("res://assets/peeled_potato.png"), preload("res://assets/boiled_potato.png"),
				preload("res://assets/pot.png"), null]

"""
  tile addition checklist
image to assets folder
add to tileset
add to constants, breaktos and names here
add texture to textures dict here
increase max_item_id here
add to languages (text.csv file)
if needed:
add to no_spawning_on in mobspawning.gd
add to block_smell in mapupdater.gd
"""



var normal_player_pos = Vector2()
var editing_player_pos = Vector2()

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
	if prev_map == 2 and new_map == 2:
		prev_map = 0
		editing_player_pos = $player.position
	elif new_map == 2:
		
		breakto = player_breakto
		normal_player_pos = $player.position
		$player.position = editing_player_pos
	elif prev_map == 2:
		breakto = normal_breakto
		editing_player_pos = $player.position
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
	






func _process(_delta):
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
	
	
	if Input.is_action_just_pressed("lclick") and get_viewport().get_mouse_position().y > 48 and !mouse_on_monster:
		#print("b")
		#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
		#if map.get_cell(mx,my) == -1: return
		#$ui/ScrollContainer/hotbar.get_item(ROTATOR_CCW,5)
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
			if map.get_cell(mx,my) == BEETROOT and randf() < 0.01:
				map.set_cell(mx,my,GOLD)
			else:
				map.set_cell(mx,my,breakto[map.get_cell(mx,my)])
			
	if Input.is_action_just_pressed("rclick") and get_viewport().get_mouse_position().y > 48:
#		print(data_coordinates)
#		print(tile_data)
		#print(map.get_cell(mx,my))
		mouse_on_monster = false
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
	
#	if Input.is_action_just_pressed("J"):
#		if map_id == 0:
#			set_map(2)
#		elif map_id == 1:
#			set_map(2)
#		elif map_id == 2:
#			set_map(prev_map)
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
		print("world directory doesn't exist, creating.")
		d.make_dir("res://world")
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.WRITE)
	
	chunks.store_double($player.spawnpoint.x)
	chunks.store_double($player.spawnpoint.y)
	
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
	#print($player.position," ",normal_player_pos, "  ",editing_player_pos)
	data.store_double(normal_player_pos.x)
	data.store_double(normal_player_pos.y)
	data.store_double(editing_player_pos.x)
	data.store_double(editing_player_pos.y)
	data.store_16(map_id)
	data.store_16(prev_map)
	data.store_double($player.health)
	data.close()
	
	var mobs := File.new()
	mobs.open("res://world/mobs_" + string_map_ids[map_id], File.WRITE)
	for mob in $mobs.get_children():
		mobs.store_16(mob.type)
		mobs.store_double(mob.position.x)
		mobs.store_double(mob.position.y)
		mobs.store_double(mob.health)
		mobs.store_64(0)
		mobs.store_64(0)
		mobs.store_64(0)
		mobs.store_64(0)
		
	mobs.close()
	
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
	
	for m in $mobs.get_children(): m.queue_free()
	
	var data := File.new()
	data.open("res://world/data",File.READ)
	if data.file_exists("res://world/data"):
		for s in range(data.get_16() - 4):
			$ui/ScrollContainer/hotbar.add_slot()
		for s in range($ui/ScrollContainer/hotbar.slot_num):
			$ui/ScrollContainer/hotbar.set_item(s,data.get_16(),data.get_16())
		seed_ = data.get_64()
		#$player.position.x = data.get_double()
		#$player.position.y = data.get_double()
		normal_player_pos = Vector2(data.get_double(),data.get_double())
		editing_player_pos = Vector2(data.get_double(),data.get_double())
		#print(normal_player_pos)
		set_map_no_load(data.get_16())
		if map_id == 2:
			$player.position = editing_player_pos
		else:
			$player.position = normal_player_pos
		prev_map = data.get_16()
		$player.health = data.get_double()
	else:
		print("data file not found")
	data.close()
	
	
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/map_" + string_map_ids[map_id]):
		$player.spawnpoint.x = chunks.get_double()
		$player.spawnpoint.y = chunks.get_double()
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
		print("chunks file for " + string_map_ids[map_id] + " not found")
		
	
	var mobs := File.new()
	
	mobs.open("res://world/mobs_" + string_map_ids[map_id], File.READ)

	if mobs.file_exists("res://world/mobs_" + string_map_ids[map_id]):
		#var i = 0
		var monster_scene = load("res://monster.tscn")
		while mobs.get_position() < mobs.get_len():
			var mob = monster_scene.instance()
			mob.scale = scale
			mob.type = mobs.get_16()
			mob.position = Vector2(mobs.get_double(),mobs.get_double())
			mob.health = mobs.get_double()
			$mobs.add_child(mob)
			monster_num += 1
			
			mobs.get_64()  # some free space
			mobs.get_64()
			mobs.get_64()
			mobs.get_64()
			
			#i += 1
	else:
		print("mobs file for " + string_map_ids[map_id] + " not found")
	mobs.close()
	
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
	
	for m in $mobs.get_children(): m.queue_free()
	monster_num = 0
	
	var chunks := File.new()
	chunks.open("res://world/map_" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/map_" + string_map_ids[map_id]):
		
		$player.spawnpoint.x = chunks.get_double()
		$player.spawnpoint.y = chunks.get_double()
		
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
		print("chunks file for " + string_map_ids[map_id] + " not found")
	
	var mobs := File.new()
	
	mobs.open("res://world/mobs_" + string_map_ids[map_id], File.READ)

	if mobs.file_exists("res://world/mobs_" + string_map_ids[map_id]):
		#var i = 0
		var monster_scene = load("res://monster.tscn")
		while mobs.get_position() < mobs.get_len():
			var mob = monster_scene.instance()
			mob.scale = scale
			mob.type = mobs.get_16()
			mob.position = Vector2(mobs.get_double(),mobs.get_double())
			mob.health = mobs.get_double()
			#print(mob)
			$mobs.add_child(mob)
			monster_num += 1
			
			mobs.get_64()
			mobs.get_64()
			mobs.get_64()
			mobs.get_64()
			
			#i += 1
	else:
		print("mobs file for " + string_map_ids[map_id] + " not found")
	mobs.close()
	
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
		chunks.get_double()
		chunks.get_double()	
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
		if map_id == 2:
			editing_player_pos = $player.position
		else:
			normal_player_pos = $player.position
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

