extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		get_parent().unpause()
		queue_free()


func _on_unpause_pressed():
	get_parent().unpause()
	queue_free()


func _on_save_pressed():
	get_parent().save_current_map()
