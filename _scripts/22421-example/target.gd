tool
extends Node2D

export var frame = 0 setget set_frame

func set_frame(new_frame):
	frame = new_frame
	if is_inside_tree(): # Needed since initial set is called before _ready
		$character_base.frame = frame
		$prison_jumpsuit.frame = frame
