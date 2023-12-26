extends RigidBody3D

const MIN_SPAWN_FORCE : float = 5000
const MAX_SPAWN_FORCE : float = 10000
const MIN_SPAWN_TORQUE : float = 0
const MAX_SPAWN_TORQUE : float = 20
const ASTEROID_HIT_POINTS : int = 100
@export var points_label: Label3D
@export var attention_shader_material: ShaderMaterial
@export var spaceship: Node3D
@onready var asteroid_explosion: Node3D = $"../AsteroidExplosion"
@onready var asteroid_hit_sound: AudioStreamPlayer3D = $"../AsteroidHitSound"
@onready var asteroid_destroyed_sound: AudioStreamPlayer3D = $"../AsteroidDestroyedSound"
@onready var asteroid_mesh: MeshInstance3D = $AsteroidMesh
@onready var game_state : GameState = get_node("/root/GameState")


func _ready() -> void:
	apply_force(Vector3.BACK * randf_range(MIN_SPAWN_FORCE, MAX_SPAWN_FORCE))
	apply_torque(
			Vector3(randf_range(MIN_SPAWN_TORQUE, MAX_SPAWN_TORQUE), 
					randf_range(MIN_SPAWN_TORQUE, MAX_SPAWN_TORQUE), 
					randf_range(MIN_SPAWN_TORQUE, MAX_SPAWN_TORQUE)))


func _on_body_entered(body: Node) -> void:
	for group : String in body.get_groups():
		if group == "LaserShotGroup":
			asteroid_explosion.position = self.position
			# Activate particle system
			asteroid_explosion.find_child("GPUParticles3D").emitting = true
			asteroid_destroyed_sound.play()
			game_state.current_points += ASTEROID_HIT_POINTS
			points_label.text = "Points: " + str(game_state.current_points)
			if game_state.high_score < game_state.current_points:
				game_state.high_score = game_state.current_points
			queue_free()


func _process(_delta: float) -> void:
	if spaceship != null:
		var spaceshipPosition: Vector3 = spaceship.find_child("RigidBody3D").position;
		
		# If we are on a direct collision path with the asteroid
		if (spaceship != null 
				and get_parent().position.x < spaceshipPosition.x + 7.5 
				and get_parent().position.x > spaceshipPosition.x - 7.5 
				and get_parent().position.y < spaceshipPosition.y + 7.5 
				and get_parent().position.y > spaceshipPosition.y - 7.5
			):
			# Add attention shader
			asteroid_mesh.material_overlay = attention_shader_material
		else:
			# Remove attention shader
			asteroid_mesh.material_overlay = null


func _on_asteroid_hit_sound_finished() -> void:
	get_parent().queue_free()
