extends Node2D


onready var obmaster = get_parent().get_parent().get_node("ObjectMaster")
onready var collmap = obmaster.get_node("CollisionMap")


# Called when the node enters the scene tree for the first time.
func _ready():
	var pos_1 = collmap.world_to_map(self.position)
	var buffer = collmap.get_cell_size()
	var pos_2 = collmap.world_to_map(self.position - buffer)
	var pos_3 = collmap.world_to_map(Vector2(self.position.x, self.position.y-buffer.y))
	var pos_4 = collmap.world_to_map(Vector2(self.position.x-buffer.x, self.position.y))
	for pos in [pos_1, pos_2, pos_3, pos_4]:
		obmaster.add_collision(pos)


