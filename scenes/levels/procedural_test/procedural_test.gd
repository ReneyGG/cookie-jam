extends Node3D

@export var scenes : Array[PackedScene]
var scenes_instance : Array
var level = 3;
var distance = 50 * level;
var start_position = Vector3(0.0, 0.0, 0.0)
var y = 0
var i = 0
var rand = 0
var is_it_start:= true

func _ready() -> void:
	start_corridors()


func initialize_corridors(scene: PackedScene) -> void:
	if is_it_start == true:
		scenes_instance.append(scene.instantiate())
		self.add_child(scenes_instance[i])
		scenes_instance[i].global_position = start_position
		start_position = scenes_instance[i].get_node("end").global_position
		print(scenes_instance[i].length)
		y += scenes_instance[i].length
		if scenes_instance[i].length == 7:
			i += 1
			scenes_instance.append(scenes[15].instantiate())
			self.add_child(scenes_instance[i])
			scenes_instance[i].global_position = scenes_instance[i - 1].get_node("room").global_position
			print("dodano pokoj")
		print("Dodano korytarz na pozycji: " + " - nazwa: ", scenes_instance[i].global_position, scenes_instance[i].name)
	else:
		scenes_instance.append(scene.instantiate())
		self.add_child(scenes_instance[i])
		scenes_instance[i].global_position = start_position
		start_position = scenes_instance[i].get_node("end").global_position
		print(scenes_instance[i].length)
		y += scenes_instance[i].length
		if scenes_instance[i].length == 7:
			i += 1
			scenes_instance.append(scenes[15].instantiate())
			self.add_child(scenes_instance[i])
			scenes_instance[i].global_position = scenes_instance[i - 1].get_node("room").global_position
			print("dodano pokoj")
		

func start_corridors() -> void:
	is_it_start = true
	y = 0
	i = 0
	rand = 0;
	while(y < 30):
		rand = randi_range(0, len(scenes) - 2)
		initialize_corridors(scenes[rand])
		i += 1
	is_it_start = false


func _on_character_new_corridor() -> void:
	rand = randi_range(0, len(scenes) - 2)
	initialize_corridors(scenes[rand])
	i += 1
