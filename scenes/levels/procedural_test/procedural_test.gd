extends Node3D

@export var scenes : Array[PackedScene]
var scenes_instance : Array
func _ready() -> void:
	pass


#func initialize_corridors() -> void:
	#var i = 0
	#for x in range(len(scenes)):
		#for y in 3:
			#scenes_instance.append(scenes[x].instantiate())
			#self.add_child(scenes_instance[y])
			#scenes_instance[y].global_position.z += i
			#i += 1
			#print("Dodano korytarz na pozycji:", scenes_instance[y].global_position)
		
