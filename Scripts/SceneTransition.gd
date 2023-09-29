# This script is an autoload, that can be accessed from any other script!

extends CanvasLayer

@onready var scene_transition_anim = $SceneTransitionAnim
@onready var dissolve_rect = $DissolveRect

enum state {
	FADE,
	SCALE
}

func _ready():
	dissolve_rect.visible = false

# You can call this funciton from any script by doing SceneTransition.load_scene(target_scene)
func load_scene(target_scene: PackedScene):
	scene_transition_anim.play("fade")
	await scene_transition_anim.animation_finished
	get_tree().change_scene_to_packed(target_scene)
	scene_transition_anim.play_backwards("fade")
