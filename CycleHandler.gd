extends Node2D

onready var wave_handler = get_node("WaveHandler")
onready var enemies = get_parent().get_node("enemies")
onready var color = get_parent().get_parent().get_node("CanvasLayer").get_node("ColorRect")
onready var music_day = get_parent().get_parent().get_node("MusicDay")
onready var music_night = get_parent().get_parent().get_node("MusicNight")

const DAY_TIME_LENGTH = 2
const FADE_TIME = 1

# Enums for times of day
const DAY = 0
const NIGHT = 1

# Colors
const DAWN_DUSK_COLOR = Color(1, 0.25, 0, 0.3)
const NIGHT_COLOR = Color(0, 0, 0.1, 0.7)

var time_of_day = DAY
var time_counter = 0
var fade_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	time_counter = 0
	music_day.play()
	pass

func _process(delta):
	if time_of_day == DAY:
		time_counter += delta
	
	if time_of_day == DAY:
		if time_counter > DAY_TIME_LENGTH - FADE_TIME:
			var fade = fade_counter / FADE_TIME
			fade_counter += delta
			if fade_counter > FADE_TIME*3/4:
				music_day.volume_db -= delta*5
			else:
				music_day.volume_db -= delta
			color.color = Color(
				NIGHT_COLOR.r, 
				NIGHT_COLOR.g, 
				NIGHT_COLOR.b, 
				NIGHT_COLOR.a * fade
			)	

		if time_counter > DAY_TIME_LENGTH:
			music_day.stop()
			music_night.play()
			wave_handler.do_next_wave()
			time_of_day = NIGHT
			time_counter = 0
			fade_counter = 0
	
	if time_of_day == NIGHT:
		if wave_handler.is_done_spawning() and enemies.get_child_count() == 0:
			if music_night.playing:
				music_night.stop()
				music_day.play()
				music_day.volume_db = 0.0
			var fade = 1 - (fade_counter / FADE_TIME)
			fade_counter += delta
			color.color = Color(
				NIGHT_COLOR.r, 
				NIGHT_COLOR.g, 
				NIGHT_COLOR.b, 
				NIGHT_COLOR.a * fade
			)
			
			if fade_counter > FADE_TIME:
				fade_counter = 0
				time_of_day = DAY
				time_counter = 0
				color.color = Color(0, 0, 0, 0)
