extends TileMap





var seed_ = 0
#var noise = OpenSimplexNoise.new()
			
var chunk_size = Vector2(16,16)

# Called when the node enters the scene tree for the first time.
func _ready():
	seed_ = get_parent().seed_
	seed(seed_)
#	chunk_size = get_parent().chunk_size
#	noise.seed = seed_
#	noise.octaves = 5
#	noise.period = 30
#	noise.persistence = 0.5
#	noise.lacunarity = 2

func generate(cx,cy): pass
#	if $generated.get_cell(cx,cy) == -1: return
#	for x in range(chunk_size.x):
#		for y in range(chunk_size.y):
#			var lx = chunk_size.x*cx+x
#			var ly = chunk_size.y*cy+y
#			var cell = -1
#
#			var noiseval = noise.get_noise_2d(lx,ly)
#
#
#			if noiseval <= 0:
#				cell = 3
#			elif noiseval < 0.1:
#				cell = 2
#			else:
#				cell = 1
#			#if get_cell(lx,ly) == -1:
#			set_cell(lx,ly,cell)
			#


#func _process(delta):
#	pass
