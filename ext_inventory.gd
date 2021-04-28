extends HBoxContainer



var tiles = [0,1,2,3,4]
var amounts=[8,2,55,13,5]

var selected = 0
var stack_limit = 5

var max_item_id = 4

var mousein = false

signal mouse_exit

var slot_num = 5

onready var slots = get_children()


func _ready():
	self.connect("mouse_exit", get_parent(), "inventory_mouse_exited", [self])
	for s in range(slot_num):
		slots[s].item = tiles[s]
		slots[s].amount = amounts[s]
		slots[s].id = s
		slots[s].max_item_id = max_item_id
		
		#slots[s].connect("gui_input", get_parent(), "slot_gui_input", [slots[s]])

				
func can_get(item, amount):
	var n = amount
	for s in range(len(slots)):
		if tiles[s] in [-1, item]:
			n -= stack_limit - amounts[s]
		if n <= 0: return true
	return false
	

func get_item(item, amount):
	if item == -1 or !can_get(item, amount): return false
	var n = amount
	for s in range(slot_num):
		if tiles[s] in [-1, item]:
			var num = amounts[s]
			set_item(s, item, num + min(n, stack_limit - num))
			n -= min(n, stack_limit - num)
		if n <= 0: return true
	print("something went wrong in get_item")
	return false

func can_lose(item, amount):
	var n = amount
	for s in range(slot_num):
		if s == item:
			n -= amounts[s]
		if n <= 0: return true
	return false

func lose_item(item, amount):
	if item == -1 or !can_lose(item, amount): return false
	var n = amount
	for s in range(slot_num):
		if tiles[slot_num-s-1] == item:
			var num = amounts[slot_num-s-1]
			print(slot_num-s-1)
			set_item(slot_num-s-1, item, num - min(n, num))
			n -= min(n, num)
		if n <= 0: return true
	print("something went wrong in 'lose_item")
	return false

func set_item(slot_id, item, amount):
	tiles[slot_id] = item
	amounts[slot_id] = amount
	slots[slot_id].item = item
	slots[slot_id].amount = amount


func _process(delta):
	if Input.is_action_just_pressed("E"): queue_free()
	
	
	if !get_global_rect().has_point(get_viewport().get_global_mouse_position()) and mousein:
		mousein = false
		emit_signal("mouse_exit")
	if get_global_rect().has_point(get_viewport().get_global_mouse_position()): mousein = true
		
		
