# This script is an autoload, that can be accessed from any other script!

extends CanvasLayer

@onready var scene_transition_anim = $SceneTransitionAnim
@onready var dissolve_rect = $DissolveRect

# Scene Transition can be changed from the inspector(Currently only 2, fade and scale. You can add more!)
enum state {FADE, SCALE}
@export var transition_type : state

func _ready():
	dissolve_rect.visible = false

# You can call this funciton from any script by doing SceneTransition.load_scene(target_scene)
#func load_scene(target_scene: PackedScene):
#	if transition_type == state.FADE:
#		scene_transition_anim.play("fade")
#		await scene_transition_anim.animation_finished
#		get_tree().change_scene_to_packed(target_scene)
#		scene_transition_anim.play_backwards("fade")
#	elif transition_type == state.SCALE:
#		scene_transition_anim.play("scale")
#		await scene_transition_anim.animation_finished
#		get_tree().change_scene_to_packed(target_scene)
#		scene_transition_anim.play_backwards("scale")

func load_scene(target_scene: PackedScene):
	match transition_type:
		state.FADE:
			transition_animation("fade", target_scene)
		state.SCALE:
			transition_animation("scale", target_scene)

func transition_animation(animation_name: String, target_scene: PackedScene):
	scene_transition_anim.play(animation_name)
	await scene_transition_anim.animation_finished
	get_tree().change_scene_to_packed(target_scene)
	scene_transition_anim.play_backwards(animation_name)
