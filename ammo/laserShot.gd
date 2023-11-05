extends RigidBody3D

func _ready() -> void:
	apply_force(Vector3.FORWARD * 10000)
