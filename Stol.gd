extends Node2D

const leg = preload("res://leg.tscn")

const FIRE_RATE = 1

onready var fire_range = $fire_range
var target = null
var fire_cooldown = 0
var health = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_target()
	shoot_at_target(delta)

func get_target():
	var bodies = fire_range.get_overlapping_bodies()
	var find_new_target = false
	if target == null:
		find_new_target = true
	elif !fire_range.overlaps_body(target):
		find_new_target = true
		target = null
	for body in bodies:
		if body.has_method("hit_by_proj"):
			target = body
			
func shoot_at_target(delta):
	if target != null and fire_cooldown <= 0:
		var proj = leg.instance()
		get_parent().get_parent().get_parent().add_child(proj)
		proj.position = self.position
		proj.shoot_towards(target.position)
		# set fire cooldown
		fire_cooldown = FIRE_RATE
	elif fire_cooldown > 0:
		fire_cooldown -= delta

func remove_coll(pos):
	var objmaster = get_parent().get_parent()
	objmaster.remove_collision(pos)

func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		remove_coll(global_position)
		queue_free()
