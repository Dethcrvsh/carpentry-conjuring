extends Node2D
var TREE_HIT_CD = 12
var hit = 0
var TREE_HP = 2
var hp = TREE_HP

onready var ObjectMaster = get_parent().get_parent()
onready var TreeDrop = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	if hit > 0:
		hit -= 1

func tree_down():
	ObjectMaster.remove_collision(self.position)
	ObjectMaster.spawn_wood_drop(self.position, "GRAN")
	queue_free()

func hit_by_axe():
	if hit == 0:
		hit = TREE_HIT_CD
		hp -= 1
		if hp == 0:
			tree_down()
			
		
