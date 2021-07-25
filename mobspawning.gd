extends Node


var monster_scene = preload("res://monster.tscn")
var main


var no_spawning_on = []


func _ready():
	
	main = get_parent()
	no_spawning_on = [main.ASDF,main.BOX,main.FRAME,main.BAUXITE,main.ALUMINIUM,main.BEETROOT,
					  main.CRAFTER,main.ACTIVEFURNACE, main.INACTIVEFURNACE, main.MERCURY]




func _process(delta):
	if main.paused: return
	if main.map_id == 2: return
	
	if randf() < 0.01:
		var dx = rand_range(-main.scale.x*main.tile_size.x*main.chunk_size.x*3,
							 main.scale.x*main.tile_size.x*main.chunk_size.x*3)
		var dy = rand_range(-main.scale.y*main.tile_size.y*main.chunk_size.y*3,
							 main.scale.y*main.tile_size.y*main.chunk_size.y*3)
		
		if abs(dx) + abs(dy) < (main.scale.x*main.tile_size.x + main.scale.y*main.tile_size.y)*20:
			return
			
		var x = main.get_node("player").position.x + dx  # 
		var y = main.get_node("player").position.y + dy
		
		
		if main.map.get_cell(x/main.scale.x/main.tile_size.x, y/main.scale.y/main.tile_size.y) in no_spawning_on: return
		
		var mob = monster_scene.instance()
		mob.scale = main.scale
		mob.type = 0
		mob.position = Vector2(x,y)
		main.get_node("kollid").add_child(mob)
		
