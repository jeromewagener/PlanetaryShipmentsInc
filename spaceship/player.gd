extends RigidBody3D

@onready var spaceship: Node3D = $spaceship
@export  var rightLaserShot: PackedScene
@export  var leftLaserShot: PackedScene

@onready var rightLaser: Node3D = $spaceship/RightLaser
@onready var leftLaser: Node3D = $spaceship/LeftLaser
@onready var followCam: Camera3D = $"../FollowCam"
@onready var right_laser_sound: AudioStreamPlayer3D = $spaceship/RightLaser/RightLaserSound
@onready var left_laser_sound: AudioStreamPlayer3D = $spaceship/LeftLaser/LeftLaserSound

var isTweeningUp = false
var isTweeningLeft = false
var isTweeningRight = false
var tweenSpaceShipTransformRotation = null
var tweenCameraTransformRotation = null

func _process(delta: float) -> void:
	spaceship.rotation = Vector3(0,0,0)
	followCam.rotation = Vector3(0,0,0)
	
	# var spaceshipMesh : MeshInstance3D = spaceship.get_child(0)
	# spaceshipMesh.set_transparency(0.9) #0.8-(clamp(abs(spaceship.global_position.x)*abs(spaceship.global_position.y-5.0),0,100)/100))
	
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
		var leftShot = leftLaserShot.instantiate()
		var rightShot = rightLaserShot.instantiate()

		add_child(leftShot)
		add_child(rightShot)

		leftShot.global_position = leftLaser.global_position
		rightShot.global_position = rightLaser.global_position
		
		#print("leftLaser --> x: " + str(leftLaser.global_position.x) + " y: " + str(leftLaser.global_position.y) + " z: " + str(leftLaser.global_position.z))
		#print("rightLaser --> x: " + str(rightLaser.global_position.x) + " y: " + str(rightLaser.global_position.y) + " z: " + str(rightLaser.global_position.z))
		
		leftShot.global_position = Vector3(leftLaser.global_position.x, leftLaser.global_position.y, leftLaser.global_position.z-1)
		leftShot.rotation = Vector3(spaceship.rotation.x, spaceship.rotation.y, spaceship.rotation.z)
		rightShot.global_position = Vector3(rightLaser.global_position.x, rightLaser.global_position.y, rightLaser.global_position.z-1)
		rightShot.rotation = Vector3(spaceship.rotation.x, spaceship.rotation.y, spaceship.rotation.z)
		
		#print("x: " + str(spaceship.global_position.x) + " y: " + str(spaceship.global_position.y) + " z: " + str(spaceship.global_position.z))
		#print(str(clamp(abs(spaceship.global_position.x)*abs(spaceship.global_position.y-5.0),0,100)))
		
		
		#print("leftShot --> x: " + str(leftShot.position.x) + " y: " + str(leftShot.position.y) + " z: " + str(leftShot.position.z))
		#print("rightShot --> x: " + str(rightShot.position.x) + " y: " + str(rightShot.position.y) + " z: " + str(rightShot.position.z))
		
		right_laser_sound.play()
		left_laser_sound.play()

		#leftShot.global_position = leftLaser.global_position
		#rightShot.global_position = rightLaser.global_position
		
		#leftShot.global_position.z -= 10
		#rightShot.global_position.z -= 10
	if Input.is_action_just_pressed("key_esc"):
		get_tree().quit()

	tweenSpaceShipTransformRotation = get_tree().create_tween().bind_node(spaceship)
	tweenSpaceShipTransformRotation.tween_property(spaceship, "rotation", spaceship.rotation, 0.5)
	tweenCameraTransformRotation = get_tree().create_tween().bind_node(followCam)
	tweenCameraTransformRotation.tween_property(followCam, "rotation", followCam.rotation, 2)


func _on_body_entered(_body: Node) -> void:
	#self.get_parent_node_3d().visible = false
	self.get_parent_node_3d().queue_free()
