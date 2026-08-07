extends Control

@onready var score_texture = %Score/ScoreTexture
@onready var score_label = %Score/ScoreLabel
@onready var lives_texture = %Lives/LivesTexture
@onready var lives_label = %Lives/LivesLabel

func _process(_delta):
	# Set the score label text to the score variable in game maanger script
	score_label.text = "x %d" % GameManager.score
	lives_label.text = "x %d" % GameManager.lives
