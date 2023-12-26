extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y = rotation.y + 0.5 * delta
	if scale.x <= 40:
		scale = scale + Vector3(0.3, 0.3, 0.3) * delta
		print("Scale: " + str(scale.x))
