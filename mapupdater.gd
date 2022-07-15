extends Node



var p# = get_parent() # main node
var map# = p.map
var psmell# = map.get_node("psmell")
var buffer# = map.get_node("buffer")
#var buffer2# = map.get_node("buffer2")
var player

var px
var py

var dir = 0
var tick = 0

var update_timer = 1

var aluminium_beet_smelting_chance = 0.05
#var furnace_deactivation_chance = 0.5
var player_smell_diffusion = 0.5
var player_smell_decay = 0.85
var error_movable = []# = [p.NONE,p.GRASS,p.SAND,p.WATER]  ## things that errors can move through

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
var dir_dict = []

# Called when the node enters the scene tree for the first time.
func _ready():
	p = get_parent() # main node
	
	error_movable = [p.NONE,p.GRASS,p.SAND,p.WATER,p.POTATO,p.MONSTER_PART,p.RAW_MONSTER_BRICK]  ## things that errors can move through
	
	for _dir in range(num_dirs):
		dir_dict.append(0)
	
	#thread = Thread.new()
	#semaphore = Semaphore.new()
	#mutex = Mutex.new()
	
	#thread.start(self, "update_smell")
	block_smell = [p.ASDF, p.BOX, p.BAUXITE, p.ALUMINIUM, p.BEETROOT, p.CRAFTER, p.ACTIVE_FURNACE, p.INACTIVE_FURNACE,
				   p.MERCURY, p.PALLADIUM, p.STOVE]


func update_smell():
	
	if p.paused: return
	
	var playercx
	var playercy
	
	map = p.map
	psmell = map.get_node("psmell")
	
	player = p.get_node("player")
	
	playercx = p.chunk_size.x*floor(player.position.x / p.chunk_size.x / p.tile_size.x / p.scale.x)
	playercy = p.chunk_size.y*floor(player.position.y / p.chunk_size.y / p.tile_size.y / p.scale.y)
	px = floor(p.get_node("player").position.x / p.tile_size.x / p.scale.x)
	py = floor(p.get_node("player").position.y / p.tile_size.y / p.scale.y)
	#print(psmell.get_cell(px,py))
	psmell.set_cell(px,py,psmell.get_cell(px,py) + 1000)
	#dir = tick%4
	#if p.map_id != 2:
	
	if p.map_id == 2: return
	
	for x in range(playercx - p.chunk_size.x*smell_r,  playercx + p.chunk_size.x*(smell_r) + 1):
		for y in range(playercy - p.chunk_size.y*smell_r,  playercy + p.chunk_size.y*(smell_r) + 1):
			#buffer.set_cell(x,y, psmell.get_cell(x,y))
			#dir = posmod(dir+1, 4)
			dir = randi()%4
			if !block_smell.has(map.get_cell(x,y)) and !block_smell.has(map.get_cellv(Vector2(x,y) + dirs[dir])):
				#dir = posmod(dir+1, 4)
				#var val = ( psmell.get_cell(x,y) + psmell.get_cellv(Vector2(x,y) + dirs[dir]) )/2
				var val = ( psmell.get_cell(x,y) + psmell.get_cellv(Vector2(x,y)+dirs[dir])*player_smell_diffusion )/(1+player_smell_diffusion)
				val *= player_smell_decay
				#val = max(0, val-20)
				psmell.set_cell(x,y, val)
#	for x in range(playercx - p.chunk_size.x*smell_r,  playercx + p.chunk_size.x*(smell_r) + 1):
#		for y in range(playercy - p.chunk_size.y*smell_r,  playercy + p.chunk_size.y*(smell_r) + 1):
#			psmell.set_cell(x,y,buffer.get_cell(x,y))
#			#buffer.set_cell(x,y,map.get_cell(x,y))
			


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
				#print(p.breakto[p.BEETROOT])
				#print(x," ",y)
				for dir in dirs:
					if map.get_cellv(c+dir) == p.BAUXITE and randf() < aluminium_beet_smelting_chance:
						buffer.set_cellv(c+dir, p.ALUMINIUM)
						buffer.set_cellv(c, p.breakto[p.BEETROOT])
						break
					
			elif cell == p.INACTIVE_FURNACE:
				for dir in dirs:
					if map.get_cellv(c+dir) == p.BEETROOT and buffer.get_cellv(c+dir) == p.BEETROOT:
						buffer.set_cellv(c+dir, p.breakto[p.BEETROOT])
						buffer.set_cellv(c, p.ACTIVE_FURNACE)
						break
			
			elif cell == p.ACTIVE_FURNACE:
				for dir in dirs:
					if map.get_cellv(c+dir) == p.BAUXITE and buffer.get_cellv(c+dir) == p.BAUXITE:
						buffer.set_cellv(c+dir, p.ALUMINIUM)
						buffer.set_cellv(c, p.INACTIVE_FURNACE)
						break
					if map.get_cellv(c+dir) == p.RAW_MONSTER_BRICK and buffer.get_cellv(c+dir) == p.RAW_MONSTER_BRICK:
						buffer.set_cellv(c+dir, p.MONSTER_BRICK)
						buffer.set_cellv(c, p.INACTIVE_FURNACE)
						break
			
			elif cell == p.CRAFTER:
				var d = map.get_cell(x,y+1)
				var l = map.get_cell(x-1,y)
				var u = map.get_cell(x,y-1)
				var r = map.get_cell(x+1,y)
				
				if d == p.breakto[p.FRAME] and l == p.ALUMINIUM and u == p.ALUMINIUM and r == p.ALUMINIUM:
					buffer.set_cell(x,y+1,p.FRAME)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.EDITOR] and l == p.FRAME and u == p.ROTATOR_CCW and r == p.HOLE:
					buffer.set_cell(x,y+1,p.EDITOR)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.INACTIVE_FURNACE] and l == p.ALUMINIUM and u == p.PALLADIUM and r == p.ASDF:
					buffer.set_cell(x,y+1,p.INACTIVE_FURNACE)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.ROTATOR_CCW] and l == p.ALUMINIUM and u == p.POTATO and r == p.ALUMINIUM:
					buffer.set_cell(x,y+1,p.ROTATOR_CCW)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.RAW_MONSTER_BRICK] and l == p.MONSTER_PART and u == p.MONSTER_PART and r == p.MONSTER_PART:
					buffer.set_cell(x,y+1,p.RAW_MONSTER_BRICK)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.STOVE] and l == p.MONSTER_BRICK and u == p.MONSTER_BRICK and r == p.INACTIVE_FURNACE:
					buffer.set_cell(x,y+1,p.STOVE)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				elif d == p.breakto[p.POT] and l == p.ALUMINIUM and u == p.FRAME and r == p.FRAME:
					buffer.set_cell(x,y+1,p.POT)
					buffer.set_cell(x-1,y,p.breakto[l])
					buffer.set_cell(x,y-1,p.breakto[u])
					buffer.set_cell(x+1,y,p.breakto[r])
				
			
			elif randf() < 0.000005 and cell == p.NONE and p.map_id != 2:
				buffer.set_cell(x,y,p.ERROR)
					
					
			elif cell == p.STOVE:
				
				if map.get_cell(x,y+1) == p.BEETROOT and buffer.get_cell(x,y+1) == p.BEETROOT:
					if map.get_cell(x,y-1) == p.POT:
						if map.get_cell(x,y-2) == p.WATER and map.get_cell(x,y-3) == p.POTATO:
							buffer.set_cell(x,y+1,p.breakto[p.BEETROOT])
							buffer.set_cell(x,y-2,p.BOILED_POTATO)
							buffer.set_cell(x,y-3,p.breakto[p.POTATO])
							
				
			elif cell == p.ERROR:
				
				var cdirs = []
				var nsmells = dir_dict.duplicate(true)
				
				
				for dir in dirs:
					var tile = map.get_cellv(c+dir)
					if error_movable.has(tile) and buffer.get_cellv(c+dir) == tile:
						cdirs.append(dirs.find(dir))
						var smell = psmell.get_cellv(c+dir)
						nsmells[dirs.find(dir)] = smell
						
				var maxsmell = nsmells.max()
				var remove = []
				
				for cdir in cdirs:
					if nsmells[cdir] != maxsmell:
						#cdirs.remove(cdir)
						remove.append(cdir)
				
				for rdir in remove:
					cdirs.remove(cdirs.find(rdir))
				
				
				if len(cdirs) != 0:
					dir = dirs[cdirs[randi()%len(cdirs)]]
					buffer.set_cellv(c, map.get_cellv(c+dir))
					buffer.set_cellv(c+dir, p.ERROR)
					
					
			elif cell == p.MERCURY and buffer.get_cell(x,y) == p.MERCURY:
				
				for dir in dirs:
					if map.get_cellv(c+dir) == p.GOLD and buffer.get_cellv(c+dir) == p.GOLD:
						buffer.set_cellv(c+dir,p.BOILED_POTATO)
				
				
				if  randf() < 10.9: # Move
					var cdirs = []
					#var nsmells = dir_dict.duplicate(true)
					
					
					for dir in dirs_moore:
						var tile = map.get_cellv(c+dir)
						if error_movable.has(tile) and buffer.get_cellv(c+dir) == tile:
							cdirs.append(dirs_moore.find(dir))
						
					if len(cdirs) != 0:
						dir = dirs_moore[cdirs[randi()%len(cdirs)]]
						buffer.set_cellv(c, map.get_cellv(c+dir))
						buffer.set_cellv(c+dir, p.MERCURY)
						
			
			
			elif cell == p.ROTATOR_CCW:
				for i in range(num_dirs):
					var ncell = map.get_cellv(c+dirs[i])
					var next = map.get_cellv(c+dirs[posmod(i-1,num_dirs)])
					if buffer.get_cellv(c+dirs[i]) == ncell and buffer.get_cellv(c+dirs[posmod(i-1,num_dirs)]) == next:
						if p.breakto[ncell] == next:
							buffer.set_cellv(c+dirs[i], next)
							buffer.set_cellv(c+dirs[posmod(i-1,num_dirs)], ncell)
			
			elif cell == p.ROTATOR_CW:
				for i in range(num_dirs):
					var ncell = map.get_cellv(c+dirs[i])
					var next = map.get_cellv(c+dirs[posmod(i+1,num_dirs)])
					if buffer.get_cellv(c+dirs[i]) == ncell and buffer.get_cellv(c+dirs[posmod(i+1,num_dirs)]) == next:
						if p.breakto[ncell] == next:
							buffer.set_cellv(c+dirs[i], next)
							buffer.set_cellv(c+dirs[posmod(i+1,num_dirs)], ncell)
					
					
			
				
#				if dir == 0 and error_movable.has(d) and buffer.get_cell(x,y+1) != p.ERROR:
#					#print("d", d)
#					buffer.set_cell(x,y,d)
#					buffer.set_cell(x,y+1,p.ERROR)
#				elif dir == 1 and error_movable.has(l) and buffer.get_cell(x-1,y) != p.ERROR:
#					#print("l", l)
#					buffer.set_cell(x,y,l)
#					buffer.set_cell(x-1,y,p.ERROR)
#				elif dir == 2 and error_movable.has(u) and buffer.get_cell(x,y-1) != p.ERROR:
#					#print("u", u)
#					buffer.set_cell(x,y,u)
#					buffer.set_cell(x,y-1,p.ERROR)
#				elif dir == 3 and error_movable.has(r) and buffer.get_cell(x+1,y) != p.ERROR:
#					#print("r", r)
#					buffer.set_cell(x,y,r)
#					buffer.set_cell(x+1,y,p.ERROR)
				#print(dirs)
				
					
	for x in range(playercx - p.chunk_size.x*tiles_r,  playercx + p.chunk_size.x*(tiles_r) + 1):
		for y in range(playercy - p.chunk_size.y*tiles_r,  playercy + p.chunk_size.y*(tiles_r) + 1):
			map.set_cell(x,y,buffer.get_cell(x,y))
			#buffer.set_cell(x,y,-1)
	


func _process(delta):
	if p.paused: return
	
	update_timer -= delta
	if update_timer <= 0:
		#if p.map_id != 2:
		update_tiles()
		update_smell()
		update_timer = 0.1
		tick += 1
		


#func _exit_tree():
	#sthread_should_exit = true
	#sthread.wait_to_finish()
