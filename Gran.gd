extends Node2D
var TREE_HIT_CD = 12
var hit = 0
var TREE_HP = 2
var hp = TREE_HP
const wood = preload("res://wood_drop.tscn")

onready var ObjectMaster = get_parent().get_parent().get_node("ObjectMaster")
onready var collmap = ObjectMaster.get_node("CollisionMap")
# Called when the node enters the scene tree for the first time.
func _ready():
	ObjectMaster.add_collision(collmap.world_to_map(self.position))

func _physics_process(delta):
	if hit > 0:
		hit -= 1

func tree_down():
	ObjectMaster.remove_collision(self.position)
	spawn_wood_drop()
	queue_free()

func hit_by_axe():
	if hit == 0:
		hit = TREE_HIT_CD
		hp -= 1
		if hp == 0:
			tree_down()
			
		
func spawn_wood_drop():
	var wood_drop_instance = wood.instance()
	get_parent().add_child(wood_drop_instance)
	wood_drop_instance.position = position
