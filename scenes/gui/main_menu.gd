extends Node

var text1 = "q"
var text2 = "qI wish I was made for loving someone"
var text3 = "qBut the only person who I can love"
var text4 = "q...is Me"
var text5 = "qI need to move deeper into my mind (WSAD)"
var text6 = "qA knife has two sides"
var text7 = "qTo hurt someone (LPM)"
var text8 = "qOr to hurt Me to feel something (PPM)"
var text9 = "qBut I need to remember"
var text10 = "qI can't die (Health Bar)"
var text11 = "qAnd can't freak out (Pleasure Bar)"
var text12 = "qIt can hurt quite a bit"
var text13 = "q"

@onready var display_label = $SceneText
@onready var game = preload("res://scenes/levels/procedural_test/procedural_test.tscn")

# Przechowywanie aktualnej linii dialogu i indeksu litery
var current_line_index = 0
var current_char_index = 0
var is_text_scrolling = false
var full_line = ""
var typing_speed = 0.05  # Czas (w sekundach) między literami
var typing_active = false  # Flaga kontrolująca, czy animacja jest aktywna
var can_click := false
var i = 2
var lines := 12

func _ready():
	$Cutscene.hide()
	$Music.play()
	$Noise.play()
	$Bg.play("mirror")
	$btn_start/AnimatedSprite2D.frame = 0
	$btn_quit/AnimatedSprite2D.frame = 0

func _process(delta):
	# Sprawdzenie kliknięcia w trakcie wyświetlania tekstu
	if Input.is_action_just_pressed("attack") and can_click:
		if is_text_scrolling:
			# Jeśli tekst jest w trakcie przewijania, wyświetl go od razu
			skip_text_animation()
		else:
			# Jeśli tekst został w pełni wyświetlony, przejdź do następnej linii
			show_next_line()

func _on_btn_start_pressed() -> void:
	Audio.play("press")
	cutscene()
	#await Audio.fin
	#get_tree().change_scene_to_file("res://scenes/levels/procedural_test/procedural_test.tscn")

func _on_btn_options_pressed() -> void:
	Audio.play("press")
	await Audio.fin
	get_tree().change_scene_to_file("res://scenes/gui/settings.tscn")

func _on_btn_quit_pressed() -> void:
	Audio.play("press")
	await Audio.fin
	get_tree().quit()

func cutscene():
	$TaintedLove.hide()
	$Or.hide()
	$btn_start.hide()
	$btn_options.hide()
	$btn_quit.hide()
	$Music.stop()
	$Bg.hide()
	$Cutscene.show()
	can_click = true

# Funkcja do wyświetlenia kolejnej linii dialogu
func show_next_line():
	if current_line_index < lines:
		if i == 13:
			$Noise.stop()
			Audio.play("stab_self")
		full_line = get("text"+str(i))
		full_line[0] = ""
		current_char_index = 0
		display_label.text = ""
		is_text_scrolling = true
		typing_active = true
		# Rozpoczynamy animację liter
		$Cutscene.frame += 1
		start_typing_text()
	else:
		#get_parent().get_parent().after_dialog()
		#animation_player.play("popout")
		get_tree().change_scene_to_packed(game)
		#queue_free()
		# Koniec dialogu, np. zamknij scenę dialogu
		#print("Koniec dialogów.")

# Funkcja stopniowo wyświetlająca tekst
func start_typing_text():
	$Typing.playing = true
	# Wywołuje się co "typing_speed" sekund, aż wyświetli cały tekst
	if typing_active:
		await get_tree().create_timer(typing_speed).timeout
		if current_char_index < full_line.length() and typing_active:
			display_label.text += full_line[current_char_index]
			current_char_index += 1
			# Kontynuujemy wyświetlanie liter, jeśli jeszcze nie skończono
			start_typing_text()
		else:
			# Cała linia została wyświetlona
			$Typing.playing = false
			is_text_scrolling = false
			typing_active = false
			#display_label.text = full_line
			current_line_index += 1
			i+=1

# Funkcja natychmiastowego wyświetlenia całego tekstu
func skip_text_animation():
	is_text_scrolling = false
	typing_active = false  # Przerywamy dalsze animowanie liter
	display_label.text = full_line

	# Zwiększ indeks dialogu na następny
	#current_line_index += 1


func _on_btn_start_mouse_entered():
	$btn_start/AnimatedSprite2D.play()

func _on_btn_quit_mouse_entered():
	$btn_quit/AnimatedSprite2D.play()

func _on_btn_quit_mouse_exited():
	$btn_quit/AnimatedSprite2D.stop()
	$btn_quit/AnimatedSprite2D.frame = 0

func _on_btn_start_mouse_exited():
	$btn_start/AnimatedSprite2D.stop()
	$btn_start/AnimatedSprite2D.frame = 0
