extends MenuButton


# Declare member variables here.
var popup
var difficulty = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	var lang = TranslationServer.get_locale()
	#print(lang, lang=="en_US")
	if lang == "en_US":
		text = "English"
	elif lang == "et":
		text = "Eesti"
	elif lang == "en_AU":
		text = "fcgvgdfffsfghfhsfrtyjn56m8s56n8"
	else:
		text = " "
	popup = get_popup()
	popup.add_item("English")
	popup.add_item("Eesti")
	popup.add_item("fcgvgdfffsfghfhsfrtyjn56m8s56n8")
	popup.add_item(" ")
	popup.connect("id_pressed", self, "_on_item_pressed")
	

#func _process(delta):
#	pass
func _on_item_pressed(ID):
	#print(popup.get_item_text(ID), " pressed")
	text = popup.get_item_text(ID)
	if text == "English":
		TranslationServer.set_locale("en_US")
	elif text == "Eesti":
		TranslationServer.set_locale("et")
	elif text == "fcgvgdfffsfghfhsfrtyjn56m8s56n8":
		TranslationServer.set_locale("en_AU")
	else:
		TranslationServer.set_locale("en_CA")
