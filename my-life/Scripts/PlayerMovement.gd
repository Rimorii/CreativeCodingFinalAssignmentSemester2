extends CharacterBody3D

@onready var camera_3d = $Camera3D

var h_sensitivity = 0.20
var v_sensitivity = 0.20

@export_category("Camera vertical angles")
@export var cam_v_min = -90.0 # degrees
@export var cam_v_max = 90.0 # degrees
var camrot_h = 0.0
var camrot_v = 0.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _input(event):

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#rotate_y(deg_to_rad(-event.relative.x * h_sensitivity))
		
		camera_3d.rotate_y(deg_to_rad(-event.relative.x * h_sensitivity))
		camera_3d.rotate_x(deg_to_rad(-event.relative.y * h_sensitivity))
		#camera_3d.rotation.x = clampf(camera_3d.rotation.x, deg_to_rad(cam_v_min), deg_to_rad(cam_v_max))
		camera_3d.rotation.x = clamp(camera_3d.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
