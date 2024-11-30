extends Control

signal options_hide()

var enable := false

func _on_btn_back_pressed() -> void:
	if enable:
		enable = false
		self.hide()
		options_hide.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
		
