extends Area2D

var collision = true
const COOLDOWN_TIMER = 100
const hp = 5
var cooldown = 0
var is_active = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func actiave_chair(thing):
	thing.become_stuck()

func remove_coll(pos):
	var objmaster = get_parent().get_parent().get_parent()
	objmaster.remove_collision(pos)

func add_coll(pos):
	var objmaster = get_parent().get_parent().get_parent()
	objmaster.add_collision(pos)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if cooldown > 0:
		cooldown -= 1

	if cooldown == 0:
		remove_coll(global_position)
		is_active = true
	
	# Trap enemies
	if cooldown == 0:
		for thing in get_overlapping_areas():
			if thing.has_method("is_enemy"):
				actiave_chair(thing)
				add_coll(global_position)
				cooldown = COOLDOWN_TIMER
				thing.allow_hit_built()
				is_active = false
				
		for thing in get_overlapping_bodies():
			if thing.has_method("is_enemy"):
				actiave_chair(thing)
				add_coll(global_position)
				cooldown = COOLDOWN_TIMER
				thing.allow_hit_built()
				is_active = false
