extends KinematicBody2D

var vel = Vector2.ZERO
var build_mode = false
var attack_timer = 0
var cooldown = 0
const SPEED = 200
const ACC = 60
const DECC = 40
const ATTACK_TIME = 0.2
const COOLDOWN_TIME = 1

onready var build_master = get_parent().get_node("BuildingMaster")
onready var rot_point = $rotation_point
onready var axe_point = $rotation_point/axe_area
onready var icon = $rotation_point/Icon

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	do_player_movement()
	do_mouse_input(delta)
	do_attack_check(delta)
	do_mode_input()

func do_player_movement():
	# Look at player input
	var move_dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		move_dir.y = -1
	if Input.is_action_pressed("move_down"):
		move_dir.y = 1
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down"):
		move_dir.y = 0
		
	if Input.is_action_pressed("move_left"):
		move_dir.x = -1
	if Input.is_action_pressed("move_right"):
		move_dir.x = 1
	if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_left"):
		move_dir.x = 0
		
	# Deccelerate if no inputs
	if move_dir.x == 0 and move_dir.y == 0:
		# If speed is close to zero then make it zero
		if vel.length() < DECC:
			vel = Vector2.ZERO
		# slow down movement
		else:
			vel = vel - vel.normalized()*DECC
	# Add run_force according to input
	else:
		var run_force = move_dir.normalized()*ACC
		vel = vel+run_force
	# stop at top speed
	vel = vel.clamped(SPEED)
	move_and_slide(vel)

func do_mouse_input(delta):
	var mous_pos = get_global_mouse_position()
	if build_mode:
		build_master.put_cursor(mous_pos)
		if Input.is_action_just_pressed("build"):
			build_master.build_at(mous_pos)
	else:
		if attack_timer <= 0:
			rot_point.look_at(mous_pos)
		if Input.is_action_just_pressed("attack") and cooldown <= 0:
			attack_timer = ATTACK_TIME
		elif cooldown > 0:
			cooldown -= delta
			
func do_attack_check(delta):
	if attack_timer > 0:
		icon.visible = true
		cooldown = COOLDOWN_TIME
		attack_timer -= delta
	else:
		icon.visible = false

func do_mode_input():
	if Input.is_action_just_pressed("mode"):
		build_mode = !build_mode
