class_name InputManager extends Node2D

@export var playerBody : PlayerBody

var inputDir := Vector2(0, 0)
var lastInputDir := Vector2(0, 0)
var mousePos := Vector2(0, 0)
var aimDir := Vector2(0, 0)

func _process(_delta : float) :
	inputDir = get_movement_direction()
	
	if inputDir != Vector2.ZERO :
		lastInputDir = inputDir
	
	mousePos = get_mouse_position()
	aimDir = get_aim_direction()
	

func get_movement_direction() -> Vector2 :
	return Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()

func get_mouse_position() -> Vector2 :
	#return get_viewport().get_mouse_position()
	return get_global_mouse_position()

func get_aim_direction() -> Vector2 :
	return (mousePos - self.global_position).normalized()

func try_aim() -> bool :
	return Input.is_action_pressed("aim")

func try_walk() -> bool :
	return Input.is_action_pressed("walk")

func try_run() -> bool :
	return Input.is_action_pressed("run")

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				print("Left mouse button")
			MOUSE_BUTTON_RIGHT:
				print("Right mouse button")
			MOUSE_BUTTON_WHEEL_UP:
				print("Scroll wheel up")
			MOUSE_BUTTON_WHEEL_DOWN:
				print("Scroll wheel down")
