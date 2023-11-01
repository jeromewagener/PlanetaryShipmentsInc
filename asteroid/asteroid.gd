extends RigidBody3D

func _ready() -> void:
	apply_force(Vector3.BACK * 5000)
