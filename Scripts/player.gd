extends CharacterBody2D

# --------- VARIABLES ---------- #


@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 400
@export var jump_force : float = 650
@export var gravity : float = 30
@export var max_jump_count : int = 2
var jump_count : int = 2

@export_category("Toggle Functions") # Double jump feature is disable by default (Can be toggled from inspector)
@export var double_jump : = false

var is_grounded : bool = false
var movement_enabled : bool = true

var is_dying_from_chocolate := false
var is_shocked := false

@onready var player_sprite = $AnimatedSprite2D
@onready var spawn_point = %SpawnPoint
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles

signal player_died(death_position: Vector2)

# --------- BUILT-IN FUNCTIONS ---------- #

func _physics_process(_delta):
	movement()

func _process(_delta):
	player_animations()
	flip_player()
	Electrocuted()


# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement():
	# Gravity
	if !is_on_floor():
		velocity.y += gravity
	elif is_on_floor():
		jump_count = max_jump_count
	
	handle_jumping()
	
	# Move Player
	var inputAxis = 0.0
	if movement_enabled:
		inputAxis = Input.get_axis("Left", "Right")
	velocity.x = inputAxis * move_speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D:
			var push_dir = -collision.get_normal()
			collider.apply_central_impulse(push_dir * move_speed * 0.05)

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_just_pressed("Jump") and movement_enabled:
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	jump_tween()
	AudioManager.jump_sfx.play()
	velocity.y = -jump_force
	
	
# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	
	if is_on_floor():
		if abs(velocity.x) > 0:
			particle_trails.emitting = true
			player_sprite.play("Walk", 1.5)
		else:
			player_sprite.play("Idle")
	else:
		player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false

# Tween Animations
func death_tween():
	movement_enabled = false
	var tween = create_tween()
	tween.tween_property(player_sprite, "scale", Vector2.ZERO, 0.15)
	tween.parallel().tween_property(player_sprite, "position", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	movement_enabled = true
	AudioManager.respawn_sfx.play()
	respawn_tween()
	
func level_complete_tween():
	movement_enabled = false
	var tween = create_tween()
	tween.tween_property(player_sprite, "scale", Vector2.ZERO, 0.15)
	tween.parallel().tween_property(player_sprite, "position", Vector2.ZERO, 0.15)
	await tween.finished
	global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	movement_enabled = true
	AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(player_sprite, "scale", Vector2(1.5,1.5), .25) 
	tween.parallel().tween_property(player_sprite, "position", Vector2(0,-48), .15)

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func death_manager():
	is_shocked = false
	is_dying_from_chocolate = false
	var death_location: Vector2 = global_position
	player_died.emit(death_location)
	AudioManager.death_sfx.play()
	death_particles.emitting = true
	if (is_shocked):
		GameManager.body_manager("normal",global_position,1)
	else:	
		GameManager.body_manager("normal",global_position,1)
	death_tween()
	
# --------- SIGNALS ---------- #›


# Reset the player's position to the current level spawn point if collided with any trap
func _on_collision_body_entered(body):
	if body.is_in_group("Traps"):
		death_manager()

func _on_collision_area_entered(area):
	if area.is_in_group("Chocolate") and !is_dying_from_chocolate:
		is_dying_from_chocolate = true
		await get_tree().create_timer(5.0).timeout
		if is_dying_from_chocolate:
			death_manager()
			is_dying_from_chocolate = false
		else:
			pass
	if area.is_in_group("Battery") and !is_shocked:
		push_warning("in player")
		is_shocked = true
		push_warning("out player")
	if area.is_in_group("catFood") :
		is_shocked = true
	if area.is_in_group("conductive"):
		push_warning("in cond")
		if is_shocked == true:
			death_manager()

# --------- Power Ups ---------- #›
func Electrocuted():
	pass
	#while is_shocked:
	#	pass
	
