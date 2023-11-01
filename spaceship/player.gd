extends RigidBody3D

@onready var spaceship: Node3D = $spaceship

var isTweeningUp = false
var isTweeningLeft = false
var isTweeningRight = false
var tweenTransformRotation = null

func _process(delta: float) -> void:
	spaceship.rotation = Vector3(0,0,0)
	
	if Input.is_action_pressed("fly_up"):
		apply_central_force(basis.y * delta * 20)
		spaceship.rotation.x += 0.4
	if Input.is_action_pressed("fly_down"):
		apply_central_force(-basis.y * delta * 20)
		spaceship.rotation.x -= 0.4
	if Input.is_action_pressed("fly_right"):
		apply_central_force(basis.x * delta * 20)
		spaceship.rotation.z -= 0.4
		spaceship.rotation.y -= 0.3
	if Input.is_action_pressed("fly_left"):
		apply_central_force(-basis.x * delta * 20)
		spaceship.rotation.z += 0.4
		spaceship.rotation.y += 0.3

	tweenTransformRotation = get_tree().create_tween().bind_node(spaceship)
	tweenTransformRotation.tween_property(spaceship, "rotation", spaceship.rotation, 0.5)
