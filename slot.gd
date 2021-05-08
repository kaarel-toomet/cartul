extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id = 0
var item = -1
var amount = 0

var max_item_id = 4



var textures = [preload("res://assets/asdf.png"), preload("res://assets/grass.png"),
				preload("res://assets/sand.png"), preload("res://assets/water.png"),
				preload("res://assets/box.png"), preload("res://assets/frame.png"), null]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item(new_item, new_amount):
	if get_parent().slot_num <= id:
		#print("wertyuiytrertyuytrertytrerrr11111111111111")
		queue_free()
		return
	get_parent().tiles[id] = new_item
	get_parent().amounts[id] = new_amount
	item = new_item
	amount = new_amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if item == 65535: set_item(-1, 0)
	if item == -1: set_item(-1,0)
	if amount == 0: set_item(-1,0)
	$amount.text = str(amount)
	if -1 <= item and item <= max_item_id:
		$texture.texture = textures[item]

