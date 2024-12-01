extends Node

func _ready():
	$Music.play()
	$Noise.play()
	$AnimatedSprite2D.play("mirror")

func _on_btn_start_pressed() -> void:
	print("dziala")
	get_tree().change_scene_to_file("res://scenes/test/test.tscn")

func _on_btn_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gui/settings.tscn")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
