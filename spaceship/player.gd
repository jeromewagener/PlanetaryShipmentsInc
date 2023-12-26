extends RigidBody3D

@onready var spaceship: Node3D = $spaceship
@export var laserShot: PackedScene

@onready var rightLaser1: Node3D = $spaceship/Lasers/RightLaser1
@onready var leftLaser1: Node3D = $spaceship/Lasers/LeftLaser1
@onready var rightLaser2: Node3D = $spaceship/Lasers/RightLaser2
@onready var leftLaser2: Node3D = $spaceship/Lasers/LeftLaser2
@onready var rightLaser3: Node3D = $spaceship/Lasers/RightLaser3
@onready var leftLaser3: Node3D = $spaceship/Lasers/LeftLaser3
@onready var followCam: Camera3D = $"../FollowCam"
@onready var right_laser_sound_1: AudioStreamPlayer3D = $spaceship/Lasers/RightLaser1/RightLaserSound1
@onready var left_laser_sound_1: AudioStreamPlayer3D = $spaceship/Lasers/LeftLaser1/LeftLaserSound1
@onready var right_laser_sound_2: AudioStreamPlayer3D = $spaceship/Lasers/RightLaser2/RightLaserSound2
@onready var left_laser_sound_2: AudioStreamPlayer3D = $spaceship/Lasers/LeftLaser2/LeftLaserSound2
@onready var right_laser_sound_3: AudioStreamPlayer3D = $spaceship/Lasers/RightLaser3/RightLaserSound3
@onready var left_laser_sound_3: AudioStreamPlayer3D = $spaceship/Lasers/LeftLaser3/LeftLaserSound3
@onready var ship_hit_audio: AudioStreamPlayer3D = $"../ShipHitAudio"
@onready var game_state = get_node("/root/GameState")

var disableControls = false
var isTweeningUp = false
var isTweeningLeft = false
var isTweeningRight = false
var tweenSpaceShipTransformRotation = null
var tweenCameraTransformRotation = null
var rng = RandomNumberGenerator.new()

# Debugging only? Apparently slow according to the documentation
var forceReadableNamesOnInstantiatedObjects : bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_esc"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")
		
	if disableControls or game_state.is_game_over:
		return
	
	spaceship.rotation = Vector3(0,0,0)
	followCam.rotation = Vector3(0,0,0)
	
	# Shaky cam... :-)
	followCam.rotation.x += rng.randf_range(-0.1, 0.1)
	followCam.rotation.y += rng.randf_range(-0.1, 0.1)
	followCam.rotation.z += rng.randf_range(-0.1, 0.1)
	
	if Input.is_action_pressed("fly_up"):
		apply_central_force(basis.y * delta * 20)
		spaceship.rotation.x += 0.4
		followCam.rotation.x += 0.1
	if Input.is_action_pressed("fly_down"):
		apply_central_force(-basis.y * delta * 20)
		spaceship.rotation.x -= 0.4
		followCam.rotation.x -= 0.1
	if Input.is_action_pressed("fly_right"):
		apply_central_force(basis.x * delta * 20)
		spaceship.rotation.z -= 0.4
		spaceship.rotation.y -= 0.3
		followCam.rotation.z -= 0.1
		followCam.rotation.y -= 0.1
	if Input.is_action_pressed("fly_left"):
		apply_central_force(-basis.x * delta * 20)
		spaceship.rotation.z += 0.4
		spaceship.rotation.y += 0.3
		followCam.rotation.z += 0.1
		followCam.rotation.y += 0.1
	if Input.is_action_just_pressed("fire_laser"):
		shot_lasers(leftLaser1, rightLaser1)
		shot_lasers(leftLaser2, rightLaser2)
		shot_lasers(leftLaser3, rightLaser3)
		right_laser_sound_1.play()
		left_laser_sound_1.play()
		right_laser_sound_2.play()
		left_laser_sound_3.play()
		right_laser_sound_3.play()
		left_laser_sound_3.play()

	tweenSpaceShipTransformRotation = get_tree().create_tween().bind_node(spaceship)
	tweenSpaceShipTransformRotation.tween_property(spaceship, "rotation", spaceship.rotation, 0.5)
	tweenCameraTransformRotation = get_tree().create_tween().bind_node(followCam)
	tweenCameraTransformRotation.tween_property(followCam, "rotation", followCam.rotation, 2)

func shot_lasers(leftLaser, rightLaser) -> void:
	var leftShot = laserShot.instantiate()
	var rightShot = laserShot.instantiate()
	add_child(leftShot, forceReadableNamesOnInstantiatedObjects)
	add_child(rightShot, forceReadableNamesOnInstantiatedObjects)
	leftShot.global_position = leftLaser.global_position
	rightShot.global_position = rightLaser.global_position
	leftShot.global_position = Vector3(leftLaser.global_position.x, leftLaser.global_position.y, leftLaser.global_position.z-1)
	leftShot.rotation = Vector3(spaceship.rotation.x, spaceship.rotation.y, spaceship.rotation.z)
	rightShot.global_position = Vector3(rightLaser.global_position.x, rightLaser.global_position.y, rightLaser.global_position.z-1)
	rightShot.rotation = Vector3(spaceship.rotation.x, spaceship.rotation.y, spaceship.rotation.z)

func _on_body_entered(_body: Node) -> void:
	# Spaceship hit
	disableControls = true
	ship_hit_audio.play()
	game_state.is_game_over = true
	gravity_scale = 2
	#self.get_parent_node_3d().visible = false
	#self.get_parent_node_3d().queue_free()
