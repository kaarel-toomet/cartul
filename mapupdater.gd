extends Node



var p # main node
var map
var psmell
var buffer

var px
var py

var dir = 0
var tick = 0

var update_timer = 1

var aluminium_beet_smelting_chance = 0.05
#var furnace_deactivation_chance = 0.5
var player_smell_diffusion = 1
var player_smell_decay = 0.85

var block_smell

var smell_r = 2
var tiles_r = 2

const D = Vector2(0,1)
const DL = Vector2(-1,1)
const L = Vector2(-1,0)
const UL = Vector2(-1,-1)
const U = Vector2(0,-1)
const UR = Vector2(1,-1)
const R = Vector2(1,0)
const DR = Vector2(1,1)



const dirs_neumann = [D,L,U,R]            # 4 adjacent neighbors
const dirs_moore = [D,DL,L,UL,U,UR,R,DR]  # 8 neighbors

var dirs = dirs_neumann
onready var num_dirs = len(dirs)

# Called when the node enters the scene tree for the first time.
func _ready():
	p = get_parent()
	map = p.map
	block_smell = [p.ASDF, p.BOX, p.BAUXITE, p.ALUMINIUM, p.BEETROOT, p.CRAFTER, p.ACTIVEFURNACE, p.INACTIVEFURNACE,
				   p.MERCURY, p.PALLADIUM]


func update_smell():
	if p.paused: return
	map = p.map
	psmell = map.get_node("psmell")
	buffer = map.get_node("buffer")
	var playercx = p.chunk_size.x*floor(p.get_node("player").position.x / p.chunk_size.x / p.tile_size.x / p.scale.x)
	var playercy = p.chunk_size.y*floor(p.get_node("player").position.y / p.chunk_size.y / p.tile_size.y / p.scale.y)
	px = floor(p.get_node("player").position.x / p.tile_size.x / p.scale.x)
	py = floor(p.get_node("player").position.y / p.tile_size.y / p.scale.y)
	
	#print(psmell.get_cell(px,py))
	psmell.set_cell(px,py,psmell.get_cell(px,py) + 1000)
	#dir = tick%4
	#if p.map_id != 2:
	
	
	for x in range(playercx - p.chunk_size.x*smell_r,  playercx + p.chunk_size.x*(smell_r) + 1):
		for y in range(playercy - p.chunk_size.y*smell_r,  playercy + p.chunk_size.y*(smell_r) + 1):
			buffer.set_cell(x,y, 0)
			#dir = posmod(dir+1, 4)
			dir = randi()%4
			if randf() < player_smell_diffusion and !block_smell.has(map.get_cell(x,y)) and !block_smell.has(map.get_cellv(Vector2(x,y) + dirs[dir])):
				#dir = posmod(dir+1, 4)
				var val = ( psmell.get_cell(x,y) + psmell.get_cellv(Vector2(x,y) + dirs[dir]) )/2
				val *= player_smell_decay
			
				buffer.set_cell(x,y, val)
	for x in range(playercx - p.chunk_size.x*smell_r,  playercx + p.chunk_size.x*(smell_r) + 1):
		for y in range(playercy - p.chunk_size.y*smell_r,  playercy + p.chunk_size.y*(smell_r) + 1):
			psmell.set_cell(x,y,buffer.get_cell(x,y))
			#buffer.set_cell(x,y,map.get_cell(x,y))
			


func update_tiles():
	if p.paused: return
	map = p.map
	psmell = map.get_node("psmell")
	buffer = map.get_node("buffer")
	var playercx = p.chunk_size.x*floor(p.get_node("player").position.x / p.chunk_size.x / p.tile_size.x / p.scale.x)
	var playercy = p.chunk_size.y*floor(p.get_node("player").position.y / p.chunk_size.y / p.tile_size.y / p.scale.y)
	px = floor(p.get_node("player").position.x / p.tile_size.x / p.scale.x)
	py = floor(p.get_node("player").position.y / p.tile_size.y / p.scale.y)
	
	for x in range(playercx - p.chunk_size.x*tiles_r,  playercx + p.chunk_size.x*(tiles_r) + 1):
		for y in range(playercy - p.chunk_size.y*tiles_r,  playercy + p.chunk_size.y*(tiles_r) + 1):
			##psmell.set_cell(x,y,buffer.get_cell(x,y))
			buffer.set_cell(x,y,map.get_cell(x,y))
			
			
	for x in range(playercx - p.chunk_size.x*tiles_r,  playercx + p.chunk_size.x*(tiles_r) + 1):
		for y in range(playercy - p.chunk_size.y*tiles_r,  playercy + p.chunk_size.y*(tiles_r) + 1):
			#buffer.set_cell(x,y,map.get_cell(x,y))
			
			var c = Vector2(x,y)
			var cell = map.get_cellv(c)
			
			if cell == p.BEETROOT:
				#print(x," ",y)
				for dir in dirs:
					if map.get_cellv(c+dir) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
						buffer.set_cellv(c+dir,y,p.ALUMINIUM)
						buffer.set_cellv(c,p.breakto[p.BEETROOT])
						break
					
			elif map.get_cell(x,y) == p.INACTIVEFURNACE:
				if map.get_cell(x+1,y) == p.BEETROOT:
					buffer.set_cell(x+1,y,p.breakto[p.BEETROOT])
					buffer.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x-1,y) == p.BEETROOT:
					buffer.set_cell(x-1,y,p.breakto[p.BEETROOT])
					buffer.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x,y+1) == p.BEETROOT:
					buffer.set_cell(x,y+1,p.breakto[p.BEETROOT])
					buffer.set_cell(x,y,p.ACTIVEFURNACE)
				elif map.get_cell(x,y-1) == p.BEETROOT:
					buffer.set_cell(x,y-1,p.breakto[p.BEETROOT])
					buffer.set_cell(x,y,p.ACTIVEFURNACE)
			
			elif map.get_cell(x,y) == p.ACTIVEFURNACE:
				if map.get_cell(x+1,y) == p.BAUXITE:
					buffer.set_cell(x+1,y,p.ALUMINIUM)
				if map.get_cell(x-1,y) == p.BAUXITE:
					buffer.set_cell(x-1,y,p.ALUMINIUM)
				if map.get_cell(x,y+1) == p.BAUXITE:
					buffer.set_cell(x,y+1,p.ALUMINIUM)
				if map.get_cell(x,y-1) == p.BAUXITE:
					buffer.set_cell(x,y-1,p.ALUMINIUM)
				buffer.set_cell(x,y,p.INACTIVEFURNACE)
			
			elif map.get_cell(x,y) == p.CRAFTER:
				var d = map.get_cell(x,y+1)
				var l = map.get_cell(x-1,y)
				var u = map.get_cell(x,y-1)
				var r = map.get_cell(x+1,y)
				
				if d == p.NONE and l == p.ALUMINIUM and u == p.ALUMINIUM and r == p.ALUMINIUM:
					buffer.set_cell(x,y+1,p.FRAME)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.NONE and l == p.ALUMINIUM and u == p.BEETROOT and r == p.HOLE:
					buffer.set_cell(x,y+1,p.EDITOR)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.NONE and l == p.ALUMINIUM and u == p.ASDF and r == p.ASDF:
					buffer.set_cell(x,y+1,p.INACTIVEFURNACE)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
			
			elif map.get_cell(x,y) == p.NONE and p.map_id != 2:
				if randf() < 0.00001:
					buffer.set_cell(x,y,p.ERROR)
					
			elif map.get_cell(x,y) == p.ERROR:
				var d = map.get_cell(x,y+1)
				var l = map.get_cell(x-1,y)
				var u = map.get_cell(x,y-1)
				var r = map.get_cell(x+1,y)
				var sd = psmell.get_cell(x,y+1)
				var sl = psmell.get_cell(x-1,y)
				var su = psmell.get_cell(x,y-1)
				var sr = psmell.get_cell(x+1,y)
				var m = [p.NONE,p.GRASS,p.SAND,p.WATER]  ## things that errors can move through
				#var n = 4
				
				var dirs = []
				if sd >= sl and sd >= su and sd >= sr: dirs.append(0)
				if sl >= sd and sl >= su and sl >= sr: dirs.append(1)
				if su >= sd and su >= sl and su >= sr: dirs.append(2)
				if sr >= sd and sr >= sl and sr >= su: dirs.append(3)
				dir = dirs[randi()%len(dirs)]
				
				if dir == 0 and m.has(d) and buffer.get_cell(x,y+1) != p.ERROR:
					#print("d", d)
					buffer.set_cell(x,y,d)
					buffer.set_cell(x,y+1,p.ERROR)
				elif dir == 1 and m.has(l) and buffer.get_cell(x-1,y) != p.ERROR:
					#print("l", l)
					buffer.set_cell(x,y,l)
					buffer.set_cell(x-1,y,p.ERROR)
				elif dir == 2 and m.has(u) and buffer.get_cell(x,y-1) != p.ERROR:
					#print("u", u)
					buffer.set_cell(x,y,u)
					buffer.set_cell(x,y-1,p.ERROR)
				elif dir == 3 and m.has(r) and buffer.get_cell(x+1,y) != p.ERROR:
					#print("r", r)
					buffer.set_cell(x,y,r)
					buffer.set_cell(x+1,y,p.ERROR)
				#print(dirs)
					
					
	for x in range(playercx - p.chunk_size.x*tiles_r,  playercx + p.chunk_size.x*(tiles_r) + 1):
		for y in range(playercy - p.chunk_size.y*tiles_r,  playercy + p.chunk_size.y*(tiles_r) + 1):
			map.set_cell(x,y,buffer.get_cell(x,y))
			#buffer.set_cell(x,y,-1)
	


func _process(delta):
	update_timer -= delta
	if update_timer <= 0:
		if p.map_id != 2:
			update_tiles()
		update_smell()
		update_timer = 0.1
		tick += 1
