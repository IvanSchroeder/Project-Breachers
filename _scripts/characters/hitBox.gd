class_name HitBox extends AreaBox

var isMonitoring : bool

@export var damage : float = 1.0 : set = set_damage, get = get_damage

func _init() -> void :
	shape = find_child("HitboxShape")
	set_layer(1)
	set_mask(0)
	monitoring = true
	monitorable = false

func set_damage(value : float) -> void :
	damage = value

func get_damage() -> float :
	return damage
