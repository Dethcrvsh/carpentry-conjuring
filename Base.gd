extends Node2D

var START_HEALTH = 500
var health = START_HEALTH

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		get_tree().quit()
		#game_over()

func game_over():
	print("Game Over")
	var camera = get_parent().get_node("Player/Camera2D")
	var main = get_parent().get_parent()
	var death_camera = main.get_node("Death").get_node("Control").get_node("Camera2D")
	death_camera.make_current()
	
