extends KinematicBody2D

var vel = Vector2.ZERO
var build_mode = false
var craft_mode = false
var dead = false
var cooldown = 0
var health = 20
var buildings = ["BlOCKSHELF", "STOL", "ARMEDCHAIR"]
var build_costs = {"BlOCKSHELF":10, "STOL":80, "ARMEDCHAIR":50}
var inv = {"BlOCKSHELF":0, "STOL":0, "ARMEDCHAIR":0}
var inv_selected_index = 0
var wood = 20
const inv_actions = {"inv_i_1":0,"inv_i_2":1,"inv_i_3":2}
const SPEED = 125
const ACC = 60
const DECC = 40
const ATTACK_TIME = 0.2
const COOLDOWN_TIME = 1
const MAX_HP = 20

onready var build_master = get_parent().get_node("ObjectMaster")
onready var rot_point = $rotation_point
onready var axe_point = $rotation_point/axe_point

const axe_attack = preload("res://axe_hitbox.tscn")
const respawn_timer = preload("res://RespawnTimer.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#for item in buildings:
	#	print(item)
	#	print(inv[item])
	do_player_movement()
	do_mouse_input(delta)
	do_mode_input()
	do_inv_check()

func do_player_movement():
	# Look at player input
	var move_dir = Vector2.ZERO
	if not dead:
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
	if not craft_mode:
		var mous_pos = get_global_mouse_position()
		if build_mode:
			build_master.put_cursor(mous_pos)
			if Input.is_action_just_pressed("build") and 0 < inv[buildings[inv_selected_index]]:
				build_master.build_at(mous_pos, buildings[inv_selected_index])
				inv[buildings[inv_selected_index]] -= 1
		else:
			if !rot_point.has_node("axe_hitbox"):
				rot_point.look_at(mous_pos)
			if Input.is_action_pressed("attack") and cooldown <= 0:
				var attack = axe_attack.instance()
				attack.position = axe_point.position
				rot_point.add_child(attack)
				cooldown = COOLDOWN_TIME
			elif cooldown > 0:
				cooldown -= delta

func do_mode_input():
	if Input.is_action_just_pressed("mode"):
		build_mode = !build_mode
		
func take_damage(dmg: int):
	print("Took " + str(dmg) + " damage")
	health -= dmg
	if health <= 0:
		die()
		
func die():
	var retimer = respawn_timer.instance()
	retimer.set_player(self)
	retimer.set_camera()
	get_parent().add_child(retimer)
	self.position = get_parent().get_node("spawn").position
	self.visible = false
	self.health = MAX_HP
	self.dead = true
		
func pickup_wood():
	wood += 5
	
func set_craft_mode(value):
	craft_mode = value
		
func do_inv_check():
	if build_mode or craft_mode:
		for i in inv_actions:
			if Input.is_action_just_pressed(i):
				inv_selected_index = inv_actions[i]
				if craft_mode and wood >= build_costs[buildings[inv_selected_index]]:
					wood -= build_costs[buildings[inv_selected_index]]
					inv[buildings[inv_selected_index]] += 1
