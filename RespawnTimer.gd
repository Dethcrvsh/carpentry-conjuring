extends Node2D


var player
var timer = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		player.visible = true
		player.get_node("Camera2D").current = true
		player.dead = false
		queue_free()
		

func set_player(obj):
	player = obj
	
func set_camera():
	$Camera2D.current = true
