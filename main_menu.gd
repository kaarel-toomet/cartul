extends Control



func _ready():
	pass

#func _process(delta):
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://main.tscn")
