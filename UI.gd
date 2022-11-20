extends Control


onready var player = get_parent().get_parent().get_node("Map").get_node("Player")
onready var text = $TextEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ui_text = ("hp:" + str(player.health) + "/" + str(player.MAX_HP) + "\n"
						+ "wood: " + str(player.wood) + "\n")
	for key in player.inv:
		ui_text += key + " : " + str(player.inv[key]) + "\n"
	ui_text += "mode: "
	if player.craft_mode:
		ui_text += "Craft\n"
	elif player.build_mode:
		ui_text += "Build\n"
	else:
		ui_text += "Axe\n"
	ui_text += "Selected: " + player.buildings[player.inv_selected_index]
	text.set_text(ui_text)
