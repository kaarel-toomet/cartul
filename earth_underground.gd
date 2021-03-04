extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()
			
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

func generate(cx,cy):
	for x in range(chunk_size.x):
		for y in range(chunk_size.y):
			var lx = chunk_size.x*cx+x
			var ly = chunk_size.y*cy+y
			var cell = -1
			
			var noiseval = abs(noise.get_noise_2d(lx,ly))
			
			
			if noiseval >= 0.1:
				cell = 0

			set_cell(lx,ly,cell)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
