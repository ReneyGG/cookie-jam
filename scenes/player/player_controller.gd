extends CharacterBody3D
#
#Player(kinematicbody)
#	Collision
#	Head(Node)
#		Camera
#		RayCast
###################-VARIABLES-####################

# Camera
@export var mouse_sensitivity := 10.0
@export var head_path: NodePath
@export var cam_path: NodePath
@export var FOV := 80.0
var mouse_axis := Vector2()
@onready var head: Node = get_node(head_path)
@onready var cam: Node = get_node(cam_path)
@onready var anim_player = $AnimationPlayer
@onready var raycast = $Head/RayCast
@onready var sprite = $Head/CanvasLayer/Control/Sprite
@onready var gui: Control = $Head/CanvasLayer/Control/GUI

# Move
#var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var can_sprint := true
var sprinting := false
# Walk
const FLOOR_NORMAL := Vector3(0, 1, 0)
@export var gravity := 30.0
@export var walk_speed := 10
@export var sprint_speed := 16
@export var acceleration := 8
@export var deacceleration := 10
@export var air_control := 0.3
@export var jump_height := 10
var player_max_health := 100
var player_current_health := player_max_health;
# Fly
@export var fly_speed := 10
@export var fly_accel := 4
var flying := false

# Slopes
#@export var floor_max_angle := 45.0

##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV
	#FIX
	#yield(get_tree(), "idle_frame")
	get_tree().call_group("enemies", "set_player", self)


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
	move_axis.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	camera_rotation()


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if flying:
		fly(delta)
	else:
		walk(delta)
	
	if Input.is_action_just_pressed("shoot") and !anim_player.is_playing():
		#anim_player.play("shoot")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
	
	if Input.is_action_just_pressed("first"):
		raycast.cast_to = Vector3(0, 0, -50)
		sprite.animation = "gun"

	if Input.is_action_just_pressed("second"):
		raycast.cast_to = Vector3(0, 0, -2)
		sprite.animation = "sword" 
 
func kill():
	get_tree().reload_current_scene()

# Called when there is an input event
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_axis = event.relative


func walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump
	var _snap: Vector3
	if is_on_floor():
		_snap = Vector3(0, -1, 0)
		if Input.is_action_just_pressed("move_jump"):
			_snap = Vector3(0, 0, 0)
			velocity.y = jump_height
	
	# Apply Gravity
	velocity.y -= gravity * delta
	
	# Sprint
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint and move_axis.x == 1):
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 8))
		sprinting = true
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target: Vector3 = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	#FIX
	#_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if velocity.x < _vel_clamp and velocity.x > -_vel_clamp:
			velocity.x = 0
		if velocity.z < _vel_clamp and velocity.z > -_vel_clamp:
			velocity.z = 0
	
	# Move
	#velocity.y = move_and_slide(velocity, _snap, FLOOR_NORMAL, true, 4, deg_to_rad(floor_max_angle)).y


func fly(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x == 1:
		direction -= aim.z
	if move_axis.x == -1:
		direction += aim.z
	if move_axis.y == -1:
		direction -= aim.x
	if move_axis.y == 1:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	#velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	#velocity = move_and_slide()


func camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var _smoothness := 80
		# Get mouse delta
		var horizontal: float = -(mouse_axis.x * mouse_sensitivity) / _smoothness
		var vertical: float = -(mouse_axis.y * mouse_sensitivity) / _smoothness
		
		mouse_axis = Vector2()
		
		rotate_y(deg_to_rad(horizontal))
		head.rotate_x(deg_to_rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot
