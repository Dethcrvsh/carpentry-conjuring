extends Node2D

var START_HEALTH = 20
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
		game_over()

func game_over():
	get_tree().change_scene("res://DeathScene.tscn")
