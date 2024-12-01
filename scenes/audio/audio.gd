extends Node

signal fin

@onready var death = $Death
@onready var stab_self = $StabSelf
@onready var stab = $Stab
@onready var hover = $Hover
@onready var press = $Press

func _ready():
	randomize()

func play(track):
	match track:
		"death":
			death.play()
		"stab_self":
			stab_self.pitch_scale = randf_range(0.8,1.0)
			stab_self.play()
		"stab":
			stab.pitch_scale = randf_range(0.8,1.2)
			stab.play()
		"hover":
			hover.play()
		"press":
			press.play()

func finished():
	emit_signal("fin")
