extends Area2D

@export var target_position: Marker2D  # drag a Marker2D node here in the Inspector
@export var target_scene: PackedScene  # optional, if teleporting to a different scene

func _on_body_entered(body):
	print("Something entered: ", body.name)
	if body.is_in_group("Player"):
		print("It's the player! Teleporting...")
		body.global_position = target_position.global_position
	else:
		print("Not in player group")
	
