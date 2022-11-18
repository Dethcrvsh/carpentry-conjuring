extends KinematicBody2D

onready var player = get_parent().get_node("Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	var player_pos = player.get_position()
	var enemy_pos = self.get_position()
	
	var vel = Vector2(
		player_pos.x - enemy_pos.x, 
		player_pos.y - enemy_pos.y
	).normalized()
	move_and_slide(vel*50)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
