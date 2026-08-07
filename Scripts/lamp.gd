extends Area2D

var original_texture: Texture2D

func _ready() -> void:
	original_texture = $Sprite2D.texture
	add_to_group("conductive")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite2D.texture = preload("res://Assets/lamp_on.jpg")

func reset():
	$Sprite2D.texture = original_texture
