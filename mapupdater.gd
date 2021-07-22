extends Node



var p # main node
var map

var update_timer = 1

var aluminium_beet_smelting_chance = 0.05
var furnace_deactivation_chance = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	p = get_parent()
	map = p.map


func update():
	map = p.map
	var playercx = p.chunk_size.x*floor(p.get_node("player").position.x / p.chunk_size.x / p.tile_size.x / p.scale.x)
	var playercy = p.chunk_size.y*floor(p.get_node("player").position.y / p.chunk_size.y / p.tile_size.y / p.scale.y)
	
	for x in range(playercx-p.chunk_size.x*2,playercx+p.chunk_size.x*3):
		for y in range(playercy-p.chunk_size.y*2,playercy+p.chunk_size.y*3):
			
			if map.get_cell(x,y) == p.BEETROOT:
				#print(x," ",y)
				if map.get_cell(x+1,y) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
					map.set_cell(x+1,y,p.ALUMINIUM)
					map.set_cell(x,y,p.breakto[p.BEETROOT])
				elif map.get_cell(x-1,y) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
					map.set_cell(x-1,y,p.ALUMINIUM)
					map.set_cell(x,y,p.breakto[p.BEETROOT])
				elif map.get_cell(x,y+1) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
					map.set_cell(x,y+1,p.ALUMINIUM)
					map.set_cell(x,y,p.breakto[p.BEETROOT])
				elif map.get_cell(x,y-1) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
					map.set_cell(x,y-1,p.ALUMINIUM)
					map.set_cell(x,y,p.breakto[p.BEETROOT])
					
			elif map.get_cell(x,y) == p.INACTIVEFURNACE:
				if map.get_cell(x+1,y) == p.BEETROOT:
					map.set_cell(x+1,y,p.breakto[p.BEETROOT])
					map.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x-1,y) == p.BEETROOT:
					map.set_cell(x-1,y,p.breakto[p.BEETROOT])
					map.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x,y+1) == p.BEETROOT:
					map.set_cell(x,y+1,p.breakto[p.BEETROOT])
					map.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x,y-1) == p.BEETROOT:
					map.set_cell(x,y-1,p.breakto[p.BEETROOT])
					map.set_cell(x,y,p.ACTIVEFURNACE)
			
			elif map.get_cell(x,y) == p.ACTIVEFURNACE:
				if map.get_cell(x+1,y) == p.BAUXITE:
					map.set_cell(x+1,y,p.ALUMINIUM)
				if map.get_cell(x-1,y) == p.BAUXITE:
					map.set_cell(x-1,y,p.ALUMINIUM)
				if map.get_cell(x,y+1) == p.BAUXITE:
					map.set_cell(x,y+1,p.ALUMINIUM)
				if map.get_cell(x,y-1) == p.BAUXITE:
					map.set_cell(x,y-1,p.ALUMINIUM)
				if randf() < furnace_deactivation_chance:
					map.set_cell(x,y,p.INACTIVEFURNACE)
			
			elif map.get_cell(x,y) == p.CRAFTER:
				var d = map.get_cell(x,y+1)
				var l = map.get_cell(x-1,y)
				var u = map.get_cell(x,y-1)
				var r = map.get_cell(x+1,y)
				
				if d == p.NONE and l == p.ALUMINIUM and u == p.ALUMINIUM and r == p.ALUMINIUM:
					map.set_cell(x,y+1,p.FRAME)
					map.set_cell(x-1,y,p.breakto[l])
					map.set_cell(x,y-1,p.breakto[u])
					map.set_cell(x+1,y,p.breakto[r])
				elif d == p.NONE and l == p.ALUMINIUM and u == p.BEETROOT and r == p.HOLE:
					map.set_cell(x,y+1,p.EDITOR)
					map.set_cell(x-1,y,p.breakto[l])
					map.set_cell(x,y-1,p.breakto[u])
					map.set_cell(x+1,y,p.breakto[r])
				elif d == p.NONE and l == p.ALUMINIUM and u == p.ASDF and r == p.ASDF:
					map.set_cell(x,y+1,p.INACTIVEFURNACE)
					map.set_cell(x-1,y,p.breakto[l])
					map.set_cell(x,y-1,p.breakto[u])
					map.set_cell(x+1,y,p.breakto[r])
				
				
	


func _process(delta):
	update_timer -= delta
	if update_timer <= 0:
		update()
		update_timer = 0.5
