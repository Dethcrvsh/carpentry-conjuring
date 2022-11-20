extends Area2D


onready var house_sprite = get_parent().get_node("outside_sprite")
onready var light = get_parent().get_node("light")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CraftArea_body_entered(body):
	house_sprite.visible = false
	light.visible = true
	if body.has_method("set_craft_mode"):
		body.set_craft_mode(true)


func _on_CraftArea_body_exited(body):
	house_sprite.visible = true
	light.visible = false
	if body.has_method("set_craft_mode"):
		body.set_craft_mode(false)
