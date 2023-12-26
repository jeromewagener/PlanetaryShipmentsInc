extends Node3D

const FINAL_WAVE : int = 22
var _random_number_generator = RandomNumberGenerator.new()
var _wave_counter : int = 1
# For debugging only? Apparently slow according to the documentation
var _force_readable_names_on_instantiated_objects : bool = true
@export var attention_shader_material : ShaderMaterial
@onready var points_label: Label3D = $PointsLabel
@onready var game_state = get_node("/root/GameState")
@onready var return_to_menu_timer: Timer = $ReturnToMenuTimer
@onready var game_finished_label: Label3D = $GameFinishedLabel
@onready var AsteroidScene : Resource = preload("res://asteroid/asteroid.tscn")


func _process(_delta: float) -> void:
	if game_state.is_game_over:
		if game_state.is_win:
			game_finished_label.text = "Mission Accomplished!"
			game_finished_label.show()
		else:
			game_finished_label.text = "Reactor is going critical:\nEJECT!!!"
			game_finished_label.show()


func spawnAsteroid() -> void:
	for i in range(_wave_counter):
		var asteroidInstance : Node3D = AsteroidScene.instantiate()
		asteroidInstance.get_child(0).points_label = points_label
		asteroidInstance.get_child(0).player = %Player
		asteroidInstance.get_child(0).attention_shader_material = attention_shader_material
		# I tried scaling the asteroids but this does not work
		# asteroidInstance.scale = asteroidInstance.scale * rng.randf_range(0.25, 2.5)
		# See: https://github.com/godotengine/godot/issues/5734
		asteroidInstance.position.z = asteroidInstance.position.z - _random_number_generator.randf_range(250, 350)
		asteroidInstance.position.x = asteroidInstance.position.x - _random_number_generator.randf_range(-32, 32)
		asteroidInstance.position.y = asteroidInstance.position.y - _random_number_generator.randf_range(-15, 20)
		add_child(asteroidInstance, _force_readable_names_on_instantiated_objects)
	_wave_counter += 1


func _on_timer_timeout():
	if _wave_counter <= FINAL_WAVE:
		spawnAsteroid()
	else:
		return_to_menu_timer.start()
		game_state.is_game_over = true
		game_state.is_win = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	for group : String in body.get_groups():
		if group == "Asteroid":
			body.get_parent().queue_free()
		if group == "player":
			return_to_menu_timer.start()
			game_state.is_game_over = true


func _on_game_over_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://menu/menu.tscn")
