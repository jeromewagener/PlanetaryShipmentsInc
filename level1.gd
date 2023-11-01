extends Node3D

var asteroid = null
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	asteroid = preload("res://asteroid/asteroid.tscn")
	spawnAsteroid()

func spawnAsteroid() -> void:
	var asteroidInstance = asteroid.instantiate()
	asteroidInstance.position.z = asteroidInstance.position.z - rng.randf_range(150, 250)
	asteroidInstance.position.x = asteroidInstance.position.x - rng.randf_range(-10, 10)
	asteroidInstance.position.y = asteroidInstance.position.y - rng.randf_range(-10, 10)
	
	add_child(asteroidInstance)

func _on_timer_timeout():
	spawnAsteroid()


func _on_area_3d_body_exited(body: Node3D) -> void:
	print(body.get_groups())
	if body.get_groups().has("player"):
		get_tree().reload_current_scene()
