extends KinematicBody2D

var vel = Vector2.ZERO
const speed = 200
const acc = 30
const decc = 50

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
	# Deccelerate if no inputs
	if move_dir.x == 0 and move_dir.y == 0:
		if vel.length() < decc:
			vel = Vector2.ZERO
		else:
			vel = vel - vel.normalized()*decc
	else:
		var run_force = move_dir.normalized()*acc
		vel = (vel+run_force).clamped(speed)
	move_and_slide(vel)
