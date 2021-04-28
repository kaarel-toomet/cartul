extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scale = Vector2(2,2)
var tile_size = Vector2(16,16)
var chunk_size = Vector2(16,16)
var gen_dist = Vector2(1,1)

var paused = false

var max_item_id = 4
var stack_limit = 5

var breakto = {-1:-1,0:2,1:2,2:3,3:-1, 4:2}

#Tile ids
#-1: void, 0: asdfstone, 1: grass, 2:sand, 3:water

var seed_ = 0

var player = preload("res://player.tscn")

var earth = preload("res://earth.tscn")
var earth_underg = preload("res://earth_underground.tscn")

var map
var map_id = 0
var map_scene_to_id = {0:earth, 1:earth_underg}
var string_map_ids = {0:"earth",1:"earth_underground"}

func set_map(new_map):
	save_current_map()
	map_id = new_map
	map.queue_free()
	map = map_scene_to_id[new_map].instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	load_map()
	map.fix_invalid_tiles()

func set_map_no_load(new_map):
	#save_current_map()
	map_id = new_map
	map.queue_free()
	map = map_scene_to_id[new_map].instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	map.fix_invalid_tiles()









func _ready():
	
	
	
	$ui.stack_limit = 5
	$ui.max_item_id = max_item_id
	$ui/hotbar.rect_scale = scale
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
	if Input.is_action_just_pressed("lclick") and get_viewport().get_mouse_position().y > 24:
		print("b")
		#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
		#if map.get_cell(mx,my) == -1: return
		if $ui/hotbar.get_item(map.get_cell(mx,my), 1):
			#print("sssssssssssssssssss")
			map.set_cell(mx,my,breakto[map.get_cell(mx,my)])
			
	if Input.is_action_just_pressed("rclick") and get_viewport().get_mouse_position().y > 24:
		var s = $ui/hotbar.selected
		var b = $ui/hotbar.tiles[s]
		if b != -1 and map.get_cell(mx,my) == breakto[b]:
			$ui/hotbar.set_item(s,b,$ui/hotbar.amounts[s]-1)
			map.set_cell(mx,my,b)
		#print($ui/hotbar.tiles,", ",$ui/hotbar.amounts)
		
	if Input.is_action_just_pressed("J"):
		if map_id == 0:
			set_map(1)
		elif map_id == 1:
			set_map(0)
	var pcx = floor($player.position.x/(tile_size.x*chunk_size.x*scale.x))
	var pcy = floor($player.position.y/(tile_size.y*chunk_size.y*scale.y))
	for cx in range(pcx-gen_dist.x,pcx+gen_dist.x+1):
		for cy in range(pcy-gen_dist.y,pcy+gen_dist.y+1):
			if map.get_node("generated").get_cell(cx,cy) == -1:
				map.generate(cx,cy)
				map.get_node("generated").set_cell(cx,cy,0)
				
				






func save_current_map():
	#print("qqqqqqsdfgh")
	var chunks := File.new()
	chunks.open("res://world/" + string_map_ids[map_id],File.WRITE)
	#print("aqqqq")
	for chunk in map.get_node("generated").get_used_cells():
		chunks.store_double(chunk.x)
		chunks.store_double(chunk.y)
		for x in range(chunk_size.x):
			for y in range(chunk_size.y):
				chunks.store_16(map.get_cell(x+chunk.x*chunk_size.x, y+chunk.y*chunk_size.y))
	chunks.close()
	var data := File.new()
	data.open("res://world/data",File.WRITE)
	#$player.position.x=-999
	for s in range(20):
		
		data.store_16($ui/hotbar.tiles[s])
		#$player.position.x=300*s
		data.store_16($ui/hotbar.amounts[s])
	#$player.position.x=999
	data.store_64(seed_)
	data.store_double($player.spawnpoint.x)
	data.store_double($player.spawnpoint.y)
	data.store_double($player.position.x)
	data.store_double($player.position.y)
	data.store_16(map_id)
	data.close()
	
	
func load_world():
	
	var data := File.new()
	data.open("res://world/data",File.READ)
	if data.file_exists("res://world/data"):
		for s in range(20):
			$ui/hotbar.set_item(s,data.get_16(),data.get_16())
		seed_ = data.get_64()
		$player.spawnpoint.x = data.get_double()
		$player.spawnpoint.y = data.get_double()
		$player.position.x = data.get_double()
		$player.position.y = data.get_double()
		set_map_no_load(data.get_16())
	else:
		print("data file not found")
	data.close()
	
	var chunks := File.new()
	chunks.open("res://world/" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/" + string_map_ids[map_id]):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_double()
			chunk.y = chunks.get_double()
			map.get_node("generated").set_cellv(chunk,0)
			for x in range(chunk_size.x):
				for y in range(chunk_size.y):
					map.set_cell(x+chunk.x*chunk_size.x,y+chunk.y*chunk_size.x,chunks.get_16())
		chunks.close()
		
	else:
		print("chunks file not found")
		
func load_map():
	var chunks := File.new()
	chunks.open("res://world/" + string_map_ids[map_id],File.READ)
	
	if chunks.file_exists("res://world/" + string_map_ids[map_id]):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_double()
			chunk.y = chunks.get_double()
			map.get_node("generated").set_cellv(chunk,0)
			for x in range(chunk_size.x):
				for y in range(chunk_size.y):
					map.set_cell(x+chunk.x*chunk_size.x,y+chunk.y*chunk_size.x,chunks.get_16())
		chunks.close()
		
	else:
		print("chunks file not found")
	
	
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

