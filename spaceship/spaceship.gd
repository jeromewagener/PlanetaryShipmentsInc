extends RigidBody3D

var _is_controller_disabled = false
var _tween_visual_rotation = null
var _tween_camera_rotation = null
var _random_number_generator = RandomNumberGenerator.new()
# Debugging only? Apparently slow according to the documentation
var _force_readable_names_on_instantiated_objects : bool = true

@export var laser_beam: PackedScene
@onready var right_laser1: Node3D = $VisualRotation/Lasers/RightLaser1
@onready var left_laser1: Node3D = $VisualRotation/Lasers/LeftLaser1
@onready var right_laser2: Node3D = $VisualRotation/Lasers/RightLaser2
@onready var left_laser2: Node3D = $VisualRotation/Lasers/LeftLaser2
@onready var right_laser3: Node3D = $VisualRotation/Lasers/RightLaser3
@onready var left_laser3: Node3D = $VisualRotation/Lasers/LeftLaser3
@onready var right_laser_sound_1: AudioStreamPlayer3D = $VisualRotation/Lasers/RightLaser1/RightLaserSound1
@onready var left_laser_sound_1: AudioStreamPlayer3D = $VisualRotation/Lasers/LeftLaser1/LeftLaserSound1
@onready var right_laser_sound_2: AudioStreamPlayer3D = $VisualRotation/Lasers/RightLaser2/RightLaserSound2
@onready var left_laser_sound_2: AudioStreamPlayer3D = $VisualRotation/Lasers/LeftLaser2/LeftLaserSound2
@onready var right_laser_sound_3: AudioStreamPlayer3D = $VisualRotation/Lasers/RightLaser3/RightLaserSound3
@onready var left_laser_sound_3: AudioStreamPlayer3D = $VisualRotation/Lasers/LeftLaser3/LeftLaserSound3
@onready var follow_cam: Camera3D = $"../FollowCam"
@onready var ship_hit_audio: AudioStreamPlayer3D = $"../ShipHitAudio"
@onready var game_state = get_node("/root/GameState")
@onready var visual_rotation: Node3D = $VisualRotation


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("key_esc"):
		get_tree().change_scene_to_file("res://menu/menu.tscn")
		
	if _is_controller_disabled or game_state.is_game_over:
		return
	
	visual_rotation.rotation = Vector3(0,0,0)
	follow_cam.rotation = Vector3(0,0,0)
	
	# Shaky cam... :-)
	follow_cam.rotation.x += _random_number_generator.randf_range(-0.1, 0.1)
	follow_cam.rotation.y += _random_number_generator.randf_range(-0.1, 0.1)
	follow_cam.rotation.z += _random_number_generator.randf_range(-0.1, 0.1)
	
	if Input.is_action_pressed("fly_up"):
		apply_central_force(basis.y * delta * 20)
		visual_rotation.rotation.x += 0.4
		follow_cam.rotation.x += 0.1
	if Input.is_action_pressed("fly_down"):
		apply_central_force(-basis.y * delta * 20)
		visual_rotation.rotation.x -= 0.4
		follow_cam.rotation.x -= 0.1
	if Input.is_action_pressed("fly_right"):
		apply_central_force(basis.x * delta * 20)
		visual_rotation.rotation.z -= 0.4
		visual_rotation.rotation.y -= 0.3
		follow_cam.rotation.z -= 0.1
		follow_cam.rotation.y -= 0.1
	if Input.is_action_pressed("fly_left"):
		apply_central_force(-basis.x * delta * 20)
		visual_rotation.rotation.z += 0.4
		visual_rotation.rotation.y += 0.3
		follow_cam.rotation.z += 0.1
		follow_cam.rotation.y += 0.1
	if Input.is_action_just_pressed("fire_laser"):
		_shoot_lasers(left_laser1, right_laser1)
		_shoot_lasers(left_laser2, right_laser2)
		_shoot_lasers(left_laser3, right_laser3)
		right_laser_sound_1.play()
		left_laser_sound_1.play()
		right_laser_sound_2.play()
		left_laser_sound_3.play()
		right_laser_sound_3.play()
		left_laser_sound_3.play()

	_tween_visual_rotation = get_tree().create_tween().bind_node(visual_rotation)
	_tween_visual_rotation.tween_property(visual_rotation, "rotation", visual_rotation.rotation, 0.5)
	_tween_camera_rotation = get_tree().create_tween().bind_node(follow_cam)
	_tween_camera_rotation.tween_property(follow_cam, "rotation", follow_cam.rotation, 2)


func _shoot_lasers(leftLaser, rightLaser) -> void:
	var left_laser_beam = laser_beam.instantiate()
	var right_laser_beam = laser_beam.instantiate()
	add_child(left_laser_beam, _force_readable_names_on_instantiated_objects)
	add_child(right_laser_beam, _force_readable_names_on_instantiated_objects)
	left_laser_beam.global_position = leftLaser.global_position
	right_laser_beam.global_position = rightLaser.global_position
	left_laser_beam.global_position = Vector3(leftLaser.global_position.x, leftLaser.global_position.y, leftLaser.global_position.z-1)
	left_laser_beam.rotation = Vector3(visual_rotation.rotation.x, visual_rotation.rotation.y, visual_rotation.rotation.z)
	right_laser_beam.global_position = Vector3(rightLaser.global_position.x, rightLaser.global_position.y, rightLaser.global_position.z-1)
	right_laser_beam.rotation = Vector3(visual_rotation.rotation.x, visual_rotation.rotation.y, visual_rotation.rotation.z)


func _on_body_entered(_body: Node) -> void:
	# Spaceship hit
	_is_controller_disabled = true
	ship_hit_audio.play()
	game_state.is_game_over = true
	gravity_scale = 2
	#self.get_parent_node_3d().visible = false
	#self.get_parent_node_3d().queue_free()
