class_name AreaBox extends Area2D

@export var enabled : bool = true :
	set = set_enable_state
var collisionLayer : int = 0 : set = set_layer, get = get_layer
var collisionMask : int = 0 : set = set_mask, get = get_mask
@export var shape : CollisionShape2D

func _ready() :
	_init()

func _init() :
	pass

func set_enable_state(value : bool) -> void :
	enabled = value
	#shape.disabled = !enabled

func set_layer(value : int) -> void :
	collisionLayer = value
	collision_layer = collisionLayer

func get_layer() -> int :
	return collisionLayer

func set_mask(value : int) -> void :
	collisionMask = value

func get_mask() -> int :
	return collisionMask
