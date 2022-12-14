extends Area2D

const SPEED = 200
const DAMAGE = 3
var velocity = Vector2()
var life_timer = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity.y = -SPEED
	set_monitoring(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate(velocity*delta)
	life_timer -= delta
	if life_timer < 0:
		queue_free()

func shoot_towards(pos):
	velocity = (pos-self.position).normalized()*SPEED
	self.look_at(pos)


func _on_Node2D_area_entered(area):
	if area.get_parent().has_method("hit_by_proj"):
		area.get_parent().hit_by_proj(DAMAGE)
		queue_free()
