extends Node

var text1 = "text1"
var text2 = "text2"
var text3 = "text3"
var text4 = "text4"
var text5 = "text5"
var text6 = "text6"
var text7 = "text7"
var text8 = "text8"
var text9 = "text9"
var text10 = "text10"
var text11 = "text11"
var text12 = "text12"
var text13 = "text13"

@onready var display_label = $SceneText

# Przechowywanie aktualnej linii dialogu i indeksu litery
var current_line_index = 0
var current_char_index = 0
var is_text_scrolling = false
var full_line = ""
var typing_speed = 0.05  # Czas (w sekundach) między literami
var typing_active = false  # Flaga kontrolująca, czy animacja jest aktywna
var can_click := false
var i = 1
var lines := 13

func _ready():
	$Cutscene.hide()
	$Music.play()
	$Noise.play()
	$Bg.play("mirror")

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
	$Label.hide()
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
		get_tree().change_scene_to_file("res://scenes/levels/procedural_test/procedural_test.tscn")
		#queue_free()
		# Koniec dialogu, np. zamknij scenę dialogu
		#print("Koniec dialogów.")

# Funkcja stopniowo wyświetlająca tekst
func start_typing_text():
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
