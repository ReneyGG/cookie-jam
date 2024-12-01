extends Control

signal enemyKilled()
signal attack_frame

@onready var animation = $AnimationPlayer
@onready var flash_animation = $FlashAnimation

var comboCounter = 0
var mouseInput
var can_attack
var can_self_attack

func _ready():
	$FlashPos.color = Color(0.0, 0.0, 0.0, 0.0)
	$Splash.frame = 0
	can_attack = true
	can_self_attack = true

func _physics_process(_delta):
	if mouseInput:
		self.position = lerp(self.position, mouseInput * -1, 0.2)
	
	if not animation.is_playing():
		animation.play("idle")

func get_hit():
	flash_animation.play("flash_neg")

func get_attack():
	flash_animation.play("flash_pos")

func changeHealthBar(d: float) -> void:
	$health_bar.value = d

func changeAdrenalineBar(d: float) -> void:
	$adrenaline_bar.value = d

func _on_combo_timer_timeout() -> void:
	$combo_meter/Label2.text = ""
	comboCounter = 0

func _on_adrenaline_timer_timeout() -> void:
	#$adrenaline_bar.value -= 1
	#$adrenaline_bar/adrenaline_timer.wait_time = 0.1
	pass

func killTimerUpdate() -> void:
	#$adrenaline_bar/adrenaline_timer.wait_time = 2
	#$adrenaline_bar.value += 10
	comboCounter += 1
	$combo_meter/Label2.text = str(comboCounter)
	$combo_meter/combo_timer.start()

func animation_attack():
	if (can_attack == true) and (can_self_attack == true):
		animation.play("attack")
		$hand/attack_timer.start()
		can_attack = false

func animation_self_attack():	
	if (can_attack == true) and (can_self_attack == true):
		animation.play("self_attack")
		$hand/self_attack_timer.start()
		can_self_attack = false

func emit_attack_frame():
	emit_signal("attack_frame")

func _on_attack_timer_timeout() -> void:
	can_attack = true

func _on_self_attack_timer_timeout() -> void:
	can_self_attack = true
