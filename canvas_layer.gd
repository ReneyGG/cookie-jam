extends CanvasLayer

func _ready() -> void:
	$pause_menu/AnimationPlayer2.play("RESET")

func resume():
	get_tree().paused = false
	$pause_menu/AnimationPlayer2.play_backwards("blur")

func pause():
	get_tree().paused = true
	$pause_menu/AnimationPlayer2.play("blur")

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()
		
func _on_btn_resume_2_pressed() -> void:
	resume()


func _on_btn_restart_2_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_btn_options_2_pressed() -> void:
	pass

func _on_btn_quit_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
	
func _process(delta: float) -> void:
	testEsc()
