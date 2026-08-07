extends Area2D

@export var amplitude := 4
@export var frequency := 5
var time_passed = 0
var initial_position := Vector2.ZERO

func _ready():
	initial_position = position
	add_to_group("Coin")

func _process(delta):
	coin_hover(delta)

func coin_hover(delta):
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

# Coin collected
func _on_body_entered(body):
	if body.is_in_group("Player"):
		AudioManager.coin_pickup_sfx.play()
		GameManager.add_score()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.1)
		await tween.finished
		deactivate()


func deactivate():
	visible = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	set_process(false)

func reset():
	visible = true
	scale = Vector2.ONE
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	set_process(true)
	time_passed = 0
	position = initial_position
