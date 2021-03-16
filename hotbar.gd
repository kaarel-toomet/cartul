extends HBoxContainer



var tiles = [0,1,2,3,0,7,8,1,1,1, 0,-1,-1,-1,-1,9,0,0,0,0]
var amounts=[0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0]

var selected = 0
var stack_limit = 5

onready var slots = [$slot1, $slot2, $slot3, $slot4, $slot5,
			 $slot6, $slot7, $slot8, $slot9, $slot10,
			 $slot11, $slot12, $slot13, $slot14, $slot15,
			 $slot16, $slot17, $slot18, $slot19, $slot20]
var textures = []



func _ready():
	
	textures.append(load("res://assets/asdf.png"))
	textures.append(load("res://assets/grass.png"))
	textures.append(load("res://assets/sand.png"))
	textures.append(load("res://assets/water.png"))
	textures.append(null)


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				selected =  posmod(selected-1,20)
			if event.button_index == BUTTON_WHEEL_DOWN:
				selected =  posmod(selected+1,20)
				#collect(21)
				
func can_get(item):
	for s in range(len(slots)):
		if tiles[s] == -1:
			return s
		if tiles[s] == item and amounts[s] < stack_limit:
			return s
	
	return -1

func get_item(item):
	var s = can_get(item)
	if s == -1 or item == -1: return false
	amounts[s] += 1
	tiles[s] = item
	return true

func has(item):
	return tiles.find(item)

func lose(item, amount):
	var s = has(item)
	if s == -1 or amounts[s] < amount: return false
	amounts[s] -= amount


func _process(delta):
	#render slots
	var i=0
	for s in slots:
		s.color = Color(0.5, 0.5, 0.5)
		
		if amounts[i] <= 0:
			tiles[i] = -1
		if tiles[i] == -1:
			amounts[i] = 0
		if tiles[i] < len(textures) and tiles[i] >= 0:
			s.get_node("texture").texture = textures[tiles[i]]
		else:
			s.get_node("texture").texture = null
		s.get_node("amount").text = str(amounts[i])
		i+=1
		
	slots[selected].color = Color(0,0,0)
		
		
