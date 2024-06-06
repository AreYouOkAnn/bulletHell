extends Node2D

@export var enemy_scenes: Array[PackedScene] = []

# @onready var player = $Player
# @onready var player_spawn_pos = $PlayerSpawnPos
@onready var laser_container = $Laser_Containment_Breach
@onready var timer = $Enemy_Timer
@onready var enemy_container = $Enemy_Container
@onready var hud = $UILAYER/HUD
@onready var game_over = $UILAYER/GameOverScreen
@onready var parallax = $ParallaxBackground
@onready var laser = $SFX/Laser
@onready var hit = $SFX/Hit
@onready var explode = $SFX/Explode

var player = null
var score := 0:
	set(value):
		score = value
		hud.score = score

var high_score 
var scroll_speed = 100

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)

	if save_file!=null:
		high_score = save_file.get_32()
	else:
		high_score = 0
		save_game()

	score = 0
	player = get_tree().get_first_node_in_group("player")
	#assert(player!=null)
	#player.global_position = player_spawn_pos.global_position
	player.laser_shot.connect(_on_player_laser_shot)
	player.killed.connect(_on_player_killed)

func _process(delta):

	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

	if timer.wait_time > 0.5:
		timer.wait_time -= delta * 0.005
	elif timer.wait_time < 0.5:
		timer.wait_time = 0.5

	parallax.scroll_offset.x += delta * scroll_speed

	if parallax.scroll_offset.x >= 2736:
		parallax.scroll_offset.x = 0

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)

func _on_player_laser_shot(laser_scene, location):
	var laser = laser_scene.instantiate()
	laser.global_position = location
	laser_container.add_child(laser)
	# laser.play()

func _on_enemy_timer_timeout():
	var e = enemy_scenes.pick_random().instantiate()
	e.global_position = Vector2(-50, randf_range(50, 1774))
	e.killed.connect(_on_enemy_killed)
#	e.hit.connect(_on_enemy_hit)
	enemy_container.add_child(e)

#func _on_enemy_hit():
#	# hit.play()
#	pass

func _on_enemy_killed(points):
	# hit.play()
	# explode.play()
	score += points
	if score > high_score:
		high_score = score

func _on_player_killed():
	# explode.play()
	game_over.set_score(score)
	game_over.set_highscore(high_score)
	save_game()
	await get_tree().create_timer(1.5).timeout
	game_over.visible = true
