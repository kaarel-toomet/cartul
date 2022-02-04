extends ColorRect



var id = 0
var item = -1
var amount = 0

onready var textures = get_parent().get_parent().get_parent().textures
onready var max_item_id = get_parent().get_parent().get_parent().max_item_id



func _ready():
	pass


func set_item(new_item, new_amount):
	if get_parent().slot_num <= id:
		#print("wertyuiytrertyuytrertytrerrr11111111111111")
		queue_free()
		return
	get_parent().tiles[id] = new_item
	get_parent().amounts[id] = new_amount
	item = new_item
	amount = new_amount


func _process(_delta):
	if item == 65535: set_item(-1, 0)
	if item == -1: set_item(-1,0)
	if amount == 0: set_item(-1,0)
	$amount.text = str(amount)
	if -1 <= item and item <= max_item_id:
		$texture.texture = textures[item]

