extends Area2D
var timer = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer <= 0:
		queue_free()

func _on_axe_hitbox_area_entered(area):
	print("swing")
	if area.get_parent().has_method("hit_by_axe"):
		area.get_parent().hit_by_axe()
