extends Node3D

@export var scenes : Array[PackedScene]
var scenes_instance : Array
var level = 1;
var distance = 50 * level;
var start_position = Vector3(0.0, 0.0, 0.0)
var y = 0
var i = 0

func _ready() -> void:
	MainTheme.play()
	random_corridor()
	pass


func initialize_corridors(scene: PackedScene) -> void:
	scenes_instance.append(scene.instantiate())
	self.add_child(scenes_instance[i])
	scenes_instance[i].global_position = start_position
	start_position = scenes_instance[i].get_node("end").global_position
	print("Dodano korytarz na pozycji: " + " - nazwa: ", scenes_instance[i].global_position, scenes_instance[i].name)

func random_corridor() -> void:
	y = 0
	i = 0
	var rand = 0;
	while(y < distance):
		rand = randi_range(0, len(scenes) - 1)
		initialize_corridors(scenes[rand])
		y += scenes_instance[i].length
		i += 1
