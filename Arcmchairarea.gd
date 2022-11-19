extends Area2D
onready var collision = $collisionarea
const COOLDOWN_TIMER = 20
const hp = 5
var cooldown = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	collision.process(false)

func collision(thing):
	collision.process(true)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if cooldown > 0:
		cooldown -= 1
		if cooldown == 0:
			collision.process(false)
		
	for thing in get_overlapping_areas():
		collision(thing)
	for thing in get_overlapping_bodies():
		collision(thing)
