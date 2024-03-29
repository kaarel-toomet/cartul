extends CanvasLayer

var max_item_id

var held = -1
var held_amount = 0
var paused = false


var slot_with_mouse = null

var stack_limit = 5

var textures
#const slot_scene = preload("res://slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	textures = get_parent().textures
	max_item_id = get_parent().max_item_id
	#$ScrollContainer/hotbar.stack_limit = stack_limit
	#$ScrollContainer/hotbar.max_item_id = max_item_id
	$ScrollContainer/hotbar.max_item_id = max_item_id
	for slot in $ScrollContainer/hotbar.get_children():
		slot.textures = textures
		slot.max_item_id = max_item_id
		#slot.connect("gui_input", self, "slot_gui_input", [slot])
		slot.connect("mouse_entered", self, "slot_mouse_entered", [slot])
		#slot.connect("mouse_exited", self, "slot_mouse_exited")



func _process(_delta):
	#if Input.is_action_just_pressed("down"): #print("asdsds")
	#if paused: return
	if held == -1 or held_amount == 0: $held_item/held_amount.text = " "
	$held_item.rect_position = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("lclick") and slot_with_mouse != null:
		#print(slot_with_mouse)
		if held != slot_with_mouse.item:
			var a = held
			var b = held_amount
			held = slot_with_mouse.item
			$held_item.texture = textures[slot_with_mouse.item]
			held_amount=slot_with_mouse.amount
			$held_item/held_amount.text = str(slot_with_mouse.amount)
			if held == -1 or held_amount == 0: $held_item/held_amount.text = " "
			slot_with_mouse.set_item(a, b)
		else:
			held_amount =  min(stack_limit, held_amount + slot_with_mouse.amount)
			$held_item/held_amount.text = str(held_amount)
			slot_with_mouse.set_item(slot_with_mouse.item,max(0, held_amount + slot_with_mouse.amount - stack_limit))

#func slot_gui_input(event: InputEvent, slot):
#	if paused: return
#	if event is InputEventMouseButton:
#
#		if event.button_index == BUTTON_LEFT and event.pressed:
#			#print("xxxxxxxxxxxxxxxaoiugadfpgföxxxx")
#			if held != slot.item:
#				var a = held
#				var b = held_amount
#				held = slot.item
#				$held_item.texture = textures[slot.item]
#				held_amount=slot.amount
#				$held_item/held_amount.text = str(slot.amount)
#				slot.set_item(a, b)
#			else:
#				held_amount =  min(stack_limit, held_amount + slot.amount)
#				$held_item/held_amount.text = str(held_amount + slot.amount)
#				slot.set_item(slot.item,min(0, held_amount + slot.amount - stack_limit))
			
				
func slot_mouse_entered(slot):
	#print(slot, " ",slot_with_mouse)
	slot_with_mouse = slot
	
	#print(slot, "eee")
	
func inventory_mouse_exited(_inventory):
	#print("x")
	slot_with_mouse = null





