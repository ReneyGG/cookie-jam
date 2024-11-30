extends Control

signal enemyKilled()

@onready var animation = $AnimationPlayer

var comboCounter = 0
var adrenaline_mult := 0.02
var mouseInput

func _physics_process(delta):
	$adrenaline_bar.value -= adrenaline_mult
	if mouseInput:
		self.position = lerp(self.position, mouseInput * -1, 0.2)

func changeHealthBar(delta: int) -> void:
	$health_bar.value = delta

func changeAdrenalineBar(delta: int) -> void:
	$adrenaline_bar.value = delta

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
	animation.play("attack")

func animation_self_attack():
	animation.play("self_attack")
