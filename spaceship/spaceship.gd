extends Node3D

var isTweeningUp = false
var isTweeningLeft = false
var isTweeningRight = false
var tweenTransformRotation = null


func _process(delta: float) -> void:
	rotation = Vector3(0,0,0)
	
	if Input.is_action_pressed("fly_up"):
		rotation.x = rotation.x + 0.4
	if Input.is_action_pressed("fly_down"):
		rotation.x = rotation.x - 0.4

	if Input.is_action_pressed("fly_right"):
		rotation.z = rotation.z - 0.4
		rotation.y = rotation.y - 0.3

	if Input.is_action_pressed("fly_left"):
		rotation.z = rotation.z + 0.4
		rotation.y = rotation.y + 0.3

	tweenTransformRotation = create_tween()
	tweenTransformRotation.tween_property(self, "rotation", rotation, 0.5)
