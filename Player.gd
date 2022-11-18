extends KinematicBody2D

var vel = Vector2.ZERO
const speed = 200
const acc = 60
const decc = 40

onready var build_master = get_parent().get_node("BuildingMaster")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_player_movement()
	do_bulding_input()

func do_player_movement():
	# Look at player input
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
		# If speed is close to zero then make it zero
		if vel.length() < decc:
			vel = Vector2.ZERO
		# slow down movement
		else:
			vel = vel - vel.normalized()*decc
	# Add run_force according to input
	else:
		var run_force = move_dir.normalized()*acc
		vel = vel+run_force
	# stop at top speed
	vel = vel.clamped(speed)
	move_and_slide(vel)

func do_bulding_input():
	var mous_pos = get_global_mouse_position()
	build_master.put_cursor(mous_pos)
	if Input.is_action_just_pressed("build"):
		build_master.build_at(mous_pos)
		
