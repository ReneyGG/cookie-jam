extends Timer


func frame_freeze(timeScale, duration):
	Engine.time_scale = timeScale
	start(duration * timeScale)

func _on_timeout():
	Engine.time_scale = 1.0
