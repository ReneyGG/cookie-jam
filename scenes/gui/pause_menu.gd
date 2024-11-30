extends CanvasLayer

signal pauseEmitter()
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var settings: Control = $settings
@onready var menu: Control = $menu


func _ready():
	animation_player.play("RESET")
	self.hide()

func resume():
	get_tree().paused = false
	animation_player.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	animation_player.play("blur")

func testEsc():
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
		self.show()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
		self.hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_btn_resume_pressed() -> void:
	resume()
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_btn_restart_pressed() -> void:
	resume()
	get_tree().reload_current_scene()
	
func _on_btn_options_pressed() -> void:
	menu.hide()
	settings.show()
	settings.enable = true

func _on_btn_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")

func _process(delta):
	testEsc()
	pauseEmitter.emit()

func _on_settings_visibility_changed() -> void:
	if settings.visible == true:
		pass
	else:
		menu.show()
