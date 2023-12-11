extends Node3D

var asteroidScene : Resource = null
var rng = RandomNumberGenerator.new()
@onready var score_label: Label3D = $ScoreLabel
@export var attentionShader : ShaderMaterial

# Debugging only? Apparently slow according to the documentation
var forceReadableNamesOnInstantiatedObjects : bool = true

func _ready() -> void:
	#print("FIRST ASTEROID")
	asteroidScene = preload("res://asteroid/asteroid.tscn")
	#spawnAsteroid()

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
			get_tree().reload_current_scene()
			# this does not work because the camera is attached to the player. So the screen goes black (or gray)
			#body.get_parent().queue_free()
	
	#print(body.get_groups())
	#if body.get_groups().has("Asteroid"):
	#	body.queue_free()
	
	# TODO JWA to fix
	# print(body.get_groups())
	# print("BUB")
	pass
	#if body.get_groups().has("player"):
	#	get_tree().reload_current_scene()
