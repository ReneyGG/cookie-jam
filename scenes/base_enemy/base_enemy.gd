extends CharacterBody3D

@export var max_health := 2
@export var move_speed := 2
@export var attack_damage := 1
@export var anim_player : Node
@export var player : Node

@onready var raycast = $RayCast3D
@onready var animation = $AnimationPlayer

var health : int
var dead = false

enum state_machine {
	IDLE,
	ATTACK,
}

var state : state_machine

func _ready():
	health = max_health
	state = state_machine.IDLE

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	match state:
		state_machine.IDLE:
			pass
		state_machine.ATTACK:
			pass
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	vec_to_player.y = 0
	raycast.target_position = vec_to_player * 3
	
	move_and_collide(vec_to_player * move_speed * delta)
	
	if raycast.is_colliding() and animation.current_animation != "attack":
		animation.play("attack")
	
	if not animation.is_playing():
		animation.play("idle")

func resolve_attack():
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		coll.hit(attack_damage)

func set_player(p):
	player = p

func hit(damage):
	health -= damage
	if health <= 0:
		dead = true
		$CollisionShape3D.disabled = true
		$RayCast3D.enabled = false
		queue_free()
		#anim_player.play("die")
