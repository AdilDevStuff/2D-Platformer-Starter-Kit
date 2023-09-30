# This script is an autoload, that can be accessed from any other script!

extends CanvasLayer

@onready var scene_transition_anim = $SceneTransitionAnim
@onready var dissolve_rect = $DissolveRect

# Scene Transition can be changed from the inspector(Currently only 2, fade and scale. You can add more!)
enum state {FADE, SCALE}
@export var transition_type : state

func _ready():
	dissolve_rect.hide() # Hide the dissolve rect

# You can call this funciton from any script by doing SceneTransition.load_scene(target_scene)
func load_scene(target_scene: PackedScene):
	match transition_type:
		state.FADE:
			transition_animation("fade", target_scene)
		state.SCALE:
			transition_animation("scale", target_scene)

# This function handles the transition animation
func transition_animation(animation_name: String, scene: PackedScene):
	scene_transition_anim.play(animation_name)
	await scene_transition_anim.animation_finished
	get_tree().change_scene_to_packed(scene)
	scene_transition_anim.play_backwards(animation_name)
