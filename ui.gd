extends CanvasLayer

var max_item_id = 4

var held = -1
var held_amount = 0

var stack_limit = 5

#const slot_scene = preload("res://slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$hotbar.stack_limit = stack_limit
	$hotbar.max_item_id = max_item_id
	for slot in $hotbar.get_children():
		slot.connect("gui_input", self, "slot_gui_input", [slot])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$held_item.rect_position = get_viewport().get_mouse_position()

func slot_gui_input(event: InputEvent, slot):
	
	if event is InputEventMouseButton:
		if event.button.index == BUTTON_LEFT and event.pressed:
			var item = slot.get_parent().tiles[slot.get_parent().slots.find(slot)]
			#if held != -1:
				
