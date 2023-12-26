extends StaticBody3D

const SPEED : int = 300


func _physics_process(delta: float) -> void:
	translate(Vector3.FORWARD * SPEED * delta)


func _on_timer_timeout() -> void:
	get_parent_node_3d().queue_free()
