extends KinematicBody2D



var type = 0

var speed = 3

var mousein = false
var health = 5

func _ready():
	pass



func _process(delta):
	var ppos = get_parent().get_parent().get_node("player").position
	move_and_slide((ppos - position).normalized()*speed*60)
	
	if mousein and Input.is_action_just_pressed("lclick"):
		health -= 1
		#print(health)
	if health <= 0:
		#print("dddddd")
		queue_free()
	
	



func _on_Area2D_mouse_entered():
	get_parent().get_parent().mouse_on_monster = true
	mousein = true


func _on_Area2D_mouse_exited():
	get_parent().get_parent().mouse_on_monster = false
	mousein = false
