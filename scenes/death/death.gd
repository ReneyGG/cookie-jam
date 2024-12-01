extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	$Screens.visible = true
	$AnimationPlayer.play("powerpoint")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/procedural_test/procedural_test.tscn")

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")
