extends Node2D

onready var collarea = $Arcmchairarea/collisionarea
onready var armarea = $Arcmchairarea
var health = 40


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func remove_coll(pos):
	var objmaster = get_parent().get_parent()
	objmaster.remove_collision(pos)

func take_dmg(dmg):
	health -= dmg
	if health <= 0:
		remove_coll(global_position)
		queue_free()
