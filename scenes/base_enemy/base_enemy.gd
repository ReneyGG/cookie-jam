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
	WALK,
}

@export var state : state_machine

func _ready():
	health = max_health
	state = state_machine.IDLE

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	
	#if animation.current_animation == "attack_1" or animation.current_animation == "attack_2":
		#state = state_machine.ATTACK
	#elif player:
		#state = state_machine.WALK
	#else:
		#state = state_machine.IDLE
	
	#if not animation.is_playing():
		#match state:
			#state_machine.IDLE:
					#animation.play("idle")
			#state_machine.WALK:
					#animation.play("walk")
			#state_machine.ATTACK:
				#var ind = [1,2].pick_random()
				#animation.play("attack_"+str(ind))
	
	var vec_to_player = player.global_position - global_position
	vec_to_player = vec_to_player.normalized()
	vec_to_player.y = 0
	raycast.target_position = vec_to_player * 3
	
	move_and_collide(vec_to_player * move_speed * delta)
	
	if raycast.is_colliding() and animation.current_animation == "walk":
		var ind = [1,2].pick_random()
		animation.play("attack_"+str(ind))
	
	if not animation.is_playing():
		animation.play("walk")
	
	print(state)

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
		animation.play("death")

func die():
	queue_free()
