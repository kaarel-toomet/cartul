extends HBoxContainer



var tiles = [4,1,2,3,0,7,8,1,1,1, 0,-1,-1,-1,-1,9,0,0,0,0]
var amounts=[5,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0]

var selected = 0
var stack_limit = 5

var max_item_id = 4

var mousein = false

signal mouse_exit

var slot_num = 20
onready var slots = [$slot1, $slot2, $slot3, $slot4, $slot5,
			 $slot6, $slot7, $slot8, $slot9, $slot10,
			 $slot11, $slot12, $slot13, $slot14, $slot15,
			 $slot16, $slot17, $slot18, $slot19, $slot20]
func _ready():
	self.connect("mouse_exit", get_parent(), "inventory_mouse_exited", [self])
	for s in range(slot_num):
		slots[s].item = tiles[s]
		slots[s].amount = amounts[s]
		slots[s].id = s
		slots[s].max_item_id = max_item_id


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				selected =  posmod(selected-1,20)
			if event.button_index == BUTTON_WHEEL_DOWN:
				selected =  posmod(selected+1,20)
				#collect(21)
				

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
	
	for s in slots:
		s.color = Color(0.5, 0.5, 0.5)
	slots[selected].color = Color(0,0,0)
	
	if !get_global_rect().has_point(get_viewport().get_mouse_position()) and mousein:
		mousein = false
		emit_signal("mouse_exit")
	if get_global_rect().has_point(get_viewport().get_mouse_position()): mousein = true
		
		
