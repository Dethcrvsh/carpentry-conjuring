extends Node2D


onready var ObjectMaster = get_parent().get_parent().get_node("ObjectMaster")
onready var collmap = ObjectMaster.get_node("CollisionMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	ObjectMaster.add_collision(self.position)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
