extends HBoxContainer



export var tiles = [1,2,3,4]
export var amounts=[5,6,7,8]

var selected = 0
var stack_limit = 5

var max_item_id = 734253647694808

var mousein = false

#signal mouse_exit


onready var main = get_parent().get_parent().get_parent()

var slot_num = 4
onready var slots = [$slot1, $slot2, $slot3, $slot4]

func _ready():
	
	#main = get_parent().get_parent().get_parent()
	
	#self.connect("mouse_exit", get_parent(), "inventory_mouse_exited", [self])
	for s in range(slot_num):
		slots[s].item = tiles[s]
		slots[s].amount = amounts[s]
		slots[s].id = s
		#slots[s].max_item_id = max_item_id


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				selected =  posmod(selected-1,slot_num)
			if event.button_index == BUTTON_WHEEL_DOWN:
				selected =  posmod(selected+1,slot_num)
				#collect(21)
				

func can_get(item, amount):
	var n = amount
	for s in range(slot_num):
		if tiles[s] in [-1, item]:
			n -= stack_limit - amounts[s]
		if n <= 0: return true
	return false
	

func get_item(item, amount):
	if item == -1 or !can_get(item, amount): return false
	var n = amount
	for s in range(slot_num):
		if tiles[s] == item:
			var num = amounts[s]
			set_item(s, item, num + min(n, stack_limit - num))
			n -= min(n, stack_limit - num)
	for s in range(slot_num):
		if tiles[s] == -1:
			set_item(s, item, min(n, stack_limit))
			n -= min(n, stack_limit)
		if n <= 0: return true
	print("Error in get_item")
	return false

func can_lose(item, amount):
	var n = amount
	for s in range(slot_num):
		#print(s, " ",n)
		if tiles[s] == item:
			n -= amounts[s]
			
		if n <= 0: return true
	return false

func lose_item(item, amount):
	if item == -1 or !can_lose(item, amount): return false
	var n = amount
	for s in range(slot_num):
		if tiles[slot_num-s-1] == item:
			var num = amounts[slot_num-s-1]
			#print(slot_num-s-1)
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

func add_slot():
	var slot = load("res://slot.tscn").instance()
	add_child(slot)
	slot.connect("mouse_entered", get_parent().get_parent(), "slot_mouse_entered", [slot])
	
	slots.append(slot)
	slot.id = slot_num
	
	slot_num += 1
	amounts.append(0)
	tiles.append(-1)
	slot.set_item(-1, 0)
	
	#get_parent().rect_size.x += 9999
	

func remove_slot():
	#print(slots)
	slots[-1].queue_free()
	slot_num -= 1
	amounts.remove(len(amounts)-1)
	tiles.remove(len(tiles)-1)
	slots.remove(len(slots)-1)
	if selected >= slot_num: selected -= 1
	
	#print(slots)
	

func _process(_delta):  #. or E by default
	if Input.is_action_just_pressed("craft"):
		#print(tiles[0], " ",amounts[0],"   ",slots[0].item," ",slots[0].amount)
		if tiles[selected] == main.ALUMINIUM and can_lose(main.ALUMINIUM,5) and can_lose(main.ASDF,2): # aluminiunm → crafter
			lose_item(main.ASDF,2)
			lose_item(main.ALUMINIUM,5)
			get_item(main.CRAFTER,1)
		
		if tiles[selected] == main.ROTATOR_CCW: # flip rotator
			lose_item(main.ROTATOR_CCW,1)
			get_item(main.ROTATOR_CW,1)
		if tiles[selected] == main.ROTATOR_CW: # flip rotator
			lose_item(main.ROTATOR_CW,1)
			get_item(main.ROTATOR_CCW,1)
		
		if tiles[selected] == main.BOILED_POTATO: # eat potato
			lose_item(main.BOILED_POTATO,1)
			main.get_node("player").health += 15
		#elif tiles[selected] == 5: # frame → editor
		#	lose_item(main.FRAME,1)
		#	get_item(main.EDITOR,1)
	#print(stack_limit)
	if selected >= slot_num: selected = 0
	for s in slots:
		s.color = Color(0.5, 0.5, 0.5)
	slots[selected].color = Color(0,0,0)
	
	if !get_parent().get_global_rect().has_point(get_viewport().get_mouse_position()):# and mousein:
		mousein = false
		#print("eeeeeeeeeeeeeeeeeeeeeeeeeeee")
		get_parent().get_parent().slot_with_mouse = null
		#emit_signal("mouse_exit")
		#print("awyfg")
	if get_global_rect().has_point(get_viewport().get_mouse_position()): mousein = true
	#print(amounts)
	if amounts[len(amounts)-1] == 0 and amounts[len(amounts)-2] == 0 and slot_num > 4: remove_slot()
	elif amounts[-1] != 0: add_slot()
	get_parent().get_parent().get_node("Label2").text = get_parent().get_parent().get_parent().names[tiles[selected]]
		
		
