extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()
var bauxitenoise = OpenSimplexNoise.new()
var beetnoise = OpenSimplexNoise.new()
var widthnoise = OpenSimplexNoise.new()
			
var chunk_size = Vector2(16,16)
var seed_ = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	seed(seed_)
	seed_ = get_parent().seed_
	chunk_size = get_parent().chunk_size
	noise.seed = seed_+1
	noise.octaves = 5
	noise.period = 30
	noise.persistence = 0.5
	noise.lacunarity = 2
	widthnoise.seed = seed_+4
	widthnoise.octaves = 5
	widthnoise.period = 200
	widthnoise.persistence = 0.5
	widthnoise.lacunarity = 2
	bauxitenoise.seed = seed_+2
	bauxitenoise.octaves = 5
	bauxitenoise.period = 500
	bauxitenoise.persistence = 0.5
	bauxitenoise.lacunarity = 2
	beetnoise.seed = seed_+3
	beetnoise.octaves = 3
	beetnoise.period = 500
	beetnoise.persistence = 0.85
	beetnoise.lacunarity = 5

func generate(cx,cy):
	#if $generated.get_cell(cx,cy) == -1: return
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var lx = chunk_size.x*cx+x
			var ly = chunk_size.y*cy+y
			var cell = -1
			
			var widthnoiseval = widthnoise.get_noise_2d(lx,ly)*0.5
			var noiseval = abs(noise.get_noise_2d(lx,ly)) + widthnoiseval
			var bauxitenoiseval = bauxitenoise.get_noise_2d(lx,ly)
			var beetnoiseval = beetnoise.get_noise_2d(lx,ly)
			
			if noiseval >= 0.1:
				cell = get_parent().ASDF
				if bauxitenoiseval > 0.5: cell = get_parent().BAUXITE
			
			
			if beetnoiseval > 0.43: cell = get_parent().BEETROOT
			
			if bauxitenoiseval - beetnoiseval + rand_range(-1,1) > 1.2:
				cell = get_parent().POTATO
			
			if beetnoiseval - bauxitenoiseval - noiseval + rand_range(-2,2) > 3.25:
				cell = get_parent().PALLADIUM
			
			if beetnoiseval + bauxitenoiseval + widthnoiseval + rand_range(-2,2) > 3.25:
				cell = get_parent().MERCURY
			
			if randf() < 0.0001:
				cell = get_parent().STAIRS
			
			if get_cell(lx,ly) == -1:
				set_cell(lx,ly,cell)
			$psmell.set_cell(lx,ly,0)
			#$generated.set_cell(x,y,0)
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var lx = chunk_size.x*cx+x
			var ly = chunk_size.y*cy+y
			if randf() < 0.01*(bauxitenoise.get_noise_2d(lx,ly)+0.125):
				for i in range(-4, 5):
					for j in range(-4, 5):
						if abs(i)+abs(j)+randi()%5-2 < 3*(bauxitenoise.get_noise_2d(lx,ly)-0.2) and get_cell(lx+i,ly+j) == get_parent().ASDF:
							set_cell(lx+i,ly+j,get_parent().BAUXITE)
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
