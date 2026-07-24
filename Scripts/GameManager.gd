# This script is an autoload, that can be accessed from any other script!

extends Node2D

var bodies = preload("res://Scenes/Prefabs/bodies.tscn")
var score : int = 0
var num_bodies : int = 0
var lives : int = 9
# Adds 1 to score variable
func add_score():
	score += 1

# Loads next level
func load_next_level(next_scene : PackedScene):
	get_tree().change_scene_to_packed(next_scene)
	
# body spawning	
var last_death_location: Vector2 = Vector2.ZERO
var death_history: Array[Vector2] = []

func record_death(location: Vector2) -> void:
	last_death_location = location
	death_history.append(location)

func spawn_body(Pos: Vector2, size: float):
	if num_bodies < 8:
		lives -= 1
		num_bodies += 1
		var body1 = bodies.instantiate()
		body1.set_frozen(true)
		body1.add_to_group("spawned_bodies")
		body1.scale = Vector2(size, size)
		add_child.call_deferred(body1)
		body1.linear_velocity = Vector2.ZERO
		body1.global_position = Pos #+ Vector2(0, 3)
	else:
		level_reset()

func body_manager(type: String, Pos: Vector2, size: float):
	if type == "normal":
		spawn_body(Pos, 1.0)
	elif type == "catFood":
		spawn_body(Pos,size)


func level_reset():
	lives = 9
	num_bodies = 0
	get_tree().call_group("spawned_bodies", "queue_free")
	get_tree().call_group("Chocolate", "reset")
	get_tree().call_group("Coin", "reset")
	get_tree().call_group("CatFood", "reset")
	get_tree().call_group("Battery", "reset")
	get_tree().call_group("conductive", "reset")
