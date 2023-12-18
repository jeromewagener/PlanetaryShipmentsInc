extends StaticBody3D

func _physics_process(delta: float) -> void:
	translate(Vector3.FORWARD * 300 * delta)


func _on_timer_timeout() -> void:
	get_parent_node_3d().queue_free()
