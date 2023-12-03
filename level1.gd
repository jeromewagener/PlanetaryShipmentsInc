extends Node3D

var asteroid = null
var rng = RandomNumberGenerator.new()
@onready var score_label: Label3D = $ScoreLabel
@export var attentionShader : ShaderMaterial

func _ready() -> void:
	#print("FIRST ASTEROID")
	asteroid = preload("res://asteroid/asteroid.tscn")
	spawnAsteroid()

func spawnAsteroid() -> void:
	var asteroidInstance : Node3D = asteroid.instantiate()
	asteroidInstance.get_child(0).scoreLabel= score_label
	asteroidInstance.get_child(0).player = %player
	asteroidInstance.get_child(0).attentionShader = attentionShader
	asteroidInstance.position.z = asteroidInstance.position.z - rng.randf_range(150, 250)
	asteroidInstance.position.x = asteroidInstance.position.x - rng.randf_range(-10, 10)
	asteroidInstance.position.y = asteroidInstance.position.y - rng.randf_range(-10, 10)
	
	add_child(asteroidInstance)

func _on_timer_timeout():
	spawnAsteroid()
	pass


func _on_area_3d_body_exited(body: Node3D) -> void:
	#TODO JWA to fix
	print(body.get_groups())
	print("BUB")
	pass
	#if body.get_groups().has("player"):
	#	get_tree().reload_current_scene()
