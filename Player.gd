extends KinematicBody2D

var vel = Vector2.ZERO
const speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_player_movement()

func do_player_movement():
	var move_dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_dir.y = -1
	if Input.is_action_pressed("move_down"):
		move_dir.y = 1
	if Input.is_action_pressed("move_left"):
		move_dir.x = -1
	if Input.is_action_pressed("move_right"):
		move_dir.x = 1
	vel = move_dir.normalized()*speed
	move_and_slide(vel)
