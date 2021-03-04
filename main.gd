extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scale = Vector2(2,2)
var tile_size = Vector2(16,16)
var chunk_size = Vector2(16,16)
var gen_dist = Vector2(1,1)

var seed_ = 0

var player = preload("res://player.tscn")

var earth = preload("res://earth.tscn")
var earth_underg = preload("res://earth_underground.tscn")

var map
var map_id = earth

func set_map(new_map):
	map_id = new_map
	map.queue_free()
	map = new_map.instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	seed(seed_)
	map = earth.instance()
	map.scale = scale
	map.cell_size = tile_size
	add_child(map)
	
	var hullmyts = player.instance()
	hullmyts.scale = scale
	add_child(hullmyts)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mpos = get_global_mouse_position()
	var mx = floor(mpos.x/tile_size.x*chunk_size.x/scale.x)
	var my = floor(mpos.y/tile_size.y/chunk_size.y/scale.y)
	if Input.is_action_just_pressed("j"):
		if map_id == earth:
			set_map(earth_underg)
		elif map_id == earth_underg:
			set_map(earth)
	var pcx = floor($player.position.x/(tile_size.x*chunk_size.x*scale.x))
	var pcy = floor($player.position.y/(tile_size.y*chunk_size.y*scale.y))
	for cx in range(pcx-gen_dist.x,pcx+gen_dist.x+1):
		for cy in range(pcy-gen_dist.y,pcy+gen_dist.y+1):
			if map.get_node("generated").get_cell(cx,cy) == -1:
				map.generate(cx,cy)
				map.get_node("generated").set_cell(cx,cy,0)
