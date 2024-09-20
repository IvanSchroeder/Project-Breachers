class_name HurtBox extends AreaBox

var isMonitorable : bool

signal recieved_damage(damage : float)
@export var health : float = 100.0

func _init() -> void :
	shape = find_child("HurtboxShape")
	set_layer(0)
	set_mask(1)
	monitoring = false
	monitorable = true

func _ready() -> void :
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox : HitBox) -> void :
	if hitbox == null : return
	
	health -= hitbox.damage
	recieved_damage.emit(hitbox.damage)
	
	#if owner.has_method("take_damage") :
		#owner.take_damage(hitbox.damage)
