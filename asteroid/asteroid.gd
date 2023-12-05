extends RigidBody3D

@onready var asteroid_hit_sound: AudioStreamPlayer3D = $"../AsteroidHitSound"
@onready var asteroid_destroyed_sound: AudioStreamPlayer3D = $"../AsteroidDestroyedSound"
@export var scoreLabel: Label3D;

@onready var asteroid_model: MeshInstance3D = $AsteroidModel

@export var attentionShader: ShaderMaterial;
@export var player: Node3D;

func _ready() -> void:
	apply_force(Vector3.BACK * randf_range(5000, 10000))
	apply_torque(Vector3(randf_range(0, 20), randf_range(0, 20), randf_range(0, 20)))


func _on_body_entered(body: Node) -> void:
	asteroid_destroyed_sound.play()
	scoreLabel.text = "Score: " + str(int(scoreLabel.text.replace("Score: ",""))+100)
	queue_free()
	
func _process(delta: float) -> void:
	if player != null:
		print ("Player: x=" + str(player.get_child(0).position.x) + " y=" + str(player.get_child(0).position.y))
		print ("Asteroid: x=" + str(get_parent().position.x) + " y=" + str(get_parent().position.y))
		
		var playerPosition: Vector3 = player.get_child(0).position;
		
		if (player != null 
			and get_parent().position.x < playerPosition.x + 7.5 and get_parent().position.x > playerPosition.x - 7.5 
			and get_parent().position.y < playerPosition.y + 7.5 and get_parent().position.y > playerPosition.y - 7.5):
			asteroid_model.material_overlay = attentionShader
		else:
			#print("deactivateShader")
			asteroid_model.material_overlay = null
