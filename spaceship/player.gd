extends RigidBody3D

@onready var spaceship: Node3D = $spaceship

@export var laserShot: PackedScene
@onready var rightLaser: Node3D = $spaceship/RightLaser
@onready var leftLaser: Node3D = $spaceship/LeftLaster
@onready var camera_3d: Camera3D = $"../Camera3D"

var isTweeningUp = false
var isTweeningLeft = false
var isTweeningRight = false
var tweenTransformRotation = null
var tweenCameraTransformRotation = null

func _process(delta: float) -> void:
	spaceship.rotation = Vector3(0,0,0)
	camera_3d.rotation = Vector3(0,0,0)
	
	if Input.is_action_pressed("fly_up"):
		apply_central_force(basis.y * delta * 20)
		spaceship.rotation.x += 0.4
		camera_3d.rotation.x += 0.1
	if Input.is_action_pressed("fly_down"):
		apply_central_force(-basis.y * delta * 20)
		spaceship.rotation.x -= 0.4
		camera_3d.rotation.x -= 0.1
	if Input.is_action_pressed("fly_right"):
		apply_central_force(basis.x * delta * 20)
		spaceship.rotation.z -= 0.4
		spaceship.rotation.y -= 0.3
		camera_3d.rotation.z -= 0.1
		camera_3d.rotation.y -= 0.1
	if Input.is_action_pressed("fly_left"):
		apply_central_force(-basis.x * delta * 20)
		spaceship.rotation.z += 0.4
		spaceship.rotation.y += 0.3
		camera_3d.rotation.z += 0.1
		camera_3d.rotation.y += 0.1
	if Input.is_action_pressed("fire_laser"):
		var leftShot = laserShot.instantiate()
		var rightShot = laserShot.instantiate()
		add_child(leftShot)
		add_child(rightShot)
		leftShot.global_position = leftLaser.global_position
		rightShot.global_position = rightShot.global_position
		leftShot.global_position.z -= 10
		rightShot.global_position.z -= 10

	
	tweenTransformRotation = get_tree().create_tween().bind_node(spaceship)
	tweenTransformRotation.tween_property(spaceship, "rotation", spaceship.rotation, 0.5)
	tweenCameraTransformRotation = get_tree().create_tween().bind_node(camera_3d)
	tweenCameraTransformRotation.tween_property(camera_3d, "rotation", camera_3d.rotation, 2)
