extends Control

const LEVEL_SELECT_SCENE = "res://Scenes/LevelSelect.tscn"  # update to your actual path
const SETTINGS_SCENE = "res://Scenes/Settings.tscn"          # update to your actual path

@onready var play_button: Button = $CenterContainer/VBoxContainer/Start

@onready var quit_button: Button = $CenterContainer/VBoxContainer/Quit

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)

	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/StartGame/level_select.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_start_pressed() -> void:
	pass # Replace with function body.
