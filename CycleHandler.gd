extends Node2D

onready var wave_handler = get_node("WaveHandler")
onready var enemies = get_parent().get_node("enemies")

const DAY_TIME_LENGTH = 20

# Enums for times of day
const DAY = 0
const NIGHT = 1

var time_of_day = DAY
var time_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if time_of_day == DAY:
		time_counter += delta
	
	if time_of_day == DAY and time_counter > DAY_TIME_LENGTH:
		print("Its night!")
		wave_handler.do_next_wave()
		time_of_day = NIGHT
		time_counter = 0
	
	if time_of_day == NIGHT:
		if wave_handler.is_done_spawning() and enemies.get_child_count() == 0:
			print("Its day!")
			time_of_day = DAY
			time_counter = 0
