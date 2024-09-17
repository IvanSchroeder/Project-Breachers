class_name Trail extends Line2D

@onready var player_body = $".."

var queue : Array
@export var maxLength : int = 20

func _proccess(_delta) :
	pass

func _draw_points(node : Node2D) -> void :
	
	var pos = _get_position(node)
	
	queue.push_front(pos)
	
	if queue.size() > maxLength :
		queue.pop_back()
	
	clear_points()
	
	for point in queue:
		add_point(point)

func _get_position(node : Node2D) :
	return node.global_position
