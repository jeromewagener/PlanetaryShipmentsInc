extends StaticBody3D

func _physics_process(delta: float) -> void:
	translate(Vector3.FORWARD * 100 * delta)
