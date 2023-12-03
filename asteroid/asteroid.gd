extends RigidBody3D

@onready var asteroid_hit_sound: AudioStreamPlayer3D = $"../AsteroidHitSound"
@onready var asteroid_destroyed_sound: AudioStreamPlayer3D = $"../AsteroidDestroyedSound"
@export var scoreLabel: Label3D;

@onready var player: Node3D = %"player";

func _ready() -> void:
	apply_force(Vector3.BACK * randf_range(5000, 10000))
	apply_torque(Vector3(randf_range(0, 20), randf_range(0, 20), randf_range(0, 20)))


func _on_body_entered(body: Node) -> void:
	asteroid_destroyed_sound.play()
	scoreLabel.text = "Score: " + str(int(scoreLabel.text.replace("Score: ",""))+100)
	queue_free()
	
func _process(delta: float) -> void:	
	if (player != null 
		and position.x < player.position.x + 1 and position.x > player.position.x + 1 
		and position.y < player.position.y + 1 and position.y > player.position.y + 1):
		pass
	else:
		pass	# add shader material to asteroid
