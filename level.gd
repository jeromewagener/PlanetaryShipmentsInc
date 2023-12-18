extends Node3D

var rng = RandomNumberGenerator.new()
@onready var score_label: Label3D = $ScoreLabel
@export var attentionShader : ShaderMaterial
@onready var game_state = get_node("/root/GameState")
@onready var game_over_timer: Timer = $GameOverTimer
@onready var game_over_label: Label3D = $GameOverLabel
@onready var asteroidScene : Resource = preload("res://asteroid/asteroid.tscn")

# Debugging only? Apparently slow according to the documentation
var forceReadableNamesOnInstantiatedObjects : bool = true

func _process(delta: float) -> void:
	if game_state.isGameOver:
		game_over_label.show()

func spawnAsteroid() -> void:
	var asteroidInstance : Node3D = asteroidScene.instantiate()
	asteroidInstance.get_child(0).scoreLabel= score_label
	asteroidInstance.get_child(0).player = %Player
	asteroidInstance.get_child(0).attentionShader = attentionShader
	asteroidInstance.position.z = asteroidInstance.position.z - rng.randf_range(150, 250)
	asteroidInstance.position.x = asteroidInstance.position.x - rng.randf_range(-10, 10)
	asteroidInstance.position.y = asteroidInstance.position.y - rng.randf_range(-10, 10)
	add_child(asteroidInstance, forceReadableNamesOnInstantiatedObjects)


func _on_timer_timeout():
	spawnAsteroid()


func _on_area_3d_body_exited(body: Node3D) -> void:
	for group : String in body.get_groups():
		if group == "Asteroid":
			body.get_parent().queue_free()
		if group == "player":
			if !game_state.isGameOver:
				game_state.isGameOver = true
			game_over_timer.start()


func _on_game_over_timer_timeout() -> void:
	game_state.isGameOver = false
	get_tree().change_scene_to_file("res://menu/menu.tscn")
