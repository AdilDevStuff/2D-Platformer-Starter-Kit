extends Area2D

@export var amplitude := 4
@export var frequency := 5
var time_passed = 0
var initial_position := Vector2.ZERO

func _ready():
	initial_position = position
	add_to_group("Chocolate")

func _process(delta):
	chocolate_hover(delta)

func chocolate_hover(delta):
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

func _on_body_entered(body):
	if body.is_in_group("Player"):
		#await get_tree().create_timer(.0).timeout
		deactivate()

func deactivate():
	visible = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_process(false)

func reset():
	visible = true
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	set_process(true)
	time_passed = 0
	position = initial_position
