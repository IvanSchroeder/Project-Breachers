extends Marker2D

@onready var player = $"../PlayerCharacter"
@export_range (0.0, 1.0) var smooth = 1.0

func _process(_delta) :
	var target = player.global_position
	var target_pos_x
	var target_pos_y
	
	target_pos_x = int(lerp(global_position.x, target.x, smooth))
	target_pos_y = int(lerp(global_position.y, target.y, smooth))
	
	global_position = Vector2(target_pos_x, target_pos_y)
