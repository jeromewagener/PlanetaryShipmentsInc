extends Node3D

var rng = RandomNumberGenerator.new()
@onready var score_label: Label3D = $ScoreLabel
@export var attentionShader : ShaderMaterial
@onready var game_state = get_node("/root/GameState")
@onready var return_to_menu_timer: Timer = $ReturnToMenuTimer
@onready var game_finished_label: Label3D = $GameFinishedLabel
@onready var asteroidScene : Resource = preload("res://asteroid/asteroid.tscn")

var spawnCounter : int = 1
# Debugging only? Apparently slow according to the documentation
var forceReadableNamesOnInstantiatedObjects : bool = true

func _process(delta: float) -> void:
	if game_state.isGameOver:
		if game_state.isWin:
			game_finished_label.text = "Mission Accomplished!"
			game_finished_label.show()
		else:
			game_finished_label.text = "Reactor is going critical:\nEJECT!!!"
			game_finished_label.show()

func spawnAsteroid() -> void:
	for i in range(spawnCounter):
		var asteroidInstance : Node3D = asteroidScene.instantiate()
		asteroidInstance.get_child(0).scoreLabel= score_label
		asteroidInstance.get_child(0).player = %Player
		asteroidInstance.get_child(0).attentionShader = attentionShader
		#https://github.com/godotengine/godot/issues/5734
		#asteroidInstance.scale = asteroidInstance.scale * rng.randf_range(0.25, 2.5)
		asteroidInstance.position.z = asteroidInstance.position.z - rng.randf_range(250, 350)
		asteroidInstance.position.x = asteroidInstance.position.x - rng.randf_range(-32, 32)
		asteroidInstance.position.y = asteroidInstance.position.y - rng.randf_range(-15, 20)
		add_child(asteroidInstance, forceReadableNamesOnInstantiatedObjects)
	spawnCounter += 1

func _on_timer_timeout():
	print("Wave: " + str(spawnCounter))
	if spawnCounter <= 22:
		spawnAsteroid()
	else:
		return_to_menu_timer.start()
		game_state.isGameOver = true
		game_state.isWin = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	for group : String in body.get_groups():
		if group == "Asteroid":
			body.get_parent().queue_free()
		if group == "player":
			return_to_menu_timer.start()
			game_state.isGameOver = true


func _on_game_over_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn")
