extends Node3D

const PLANET_ROTATION_SPEED : float = 0.5
const PLANET_MAX_SCALE : float = 40
const PLANET_GROW_SPEED : float = 0.3

func _process(delta: float) -> void:
	rotation.y = rotation.y + PLANET_ROTATION_SPEED * delta
	if scale.x <= PLANET_MAX_SCALE:
		scale = scale + Vector3(PLANET_GROW_SPEED, PLANET_GROW_SPEED, PLANET_GROW_SPEED) * delta
