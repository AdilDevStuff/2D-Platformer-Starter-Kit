extends Button

var tween := create_tween()
var original_size := size
var grow_size := Vector2(1.5, 1.5)
var level_path: String


func _on_lvl_btn_mouse_entered() -> void:
	grow_size_tween(grow_size, .5)


func grow_size_tween(end_size: Vector2, duration: float) -> void:
	tween.tween_property(self, 'size', end_size, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	
func _on_button_pressed():
	get_tree().change_scene_to_file(level_path)
	
func _ready():
	pressed.connect(_on_button_pressed)
