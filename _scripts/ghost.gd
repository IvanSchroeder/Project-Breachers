extends Sprite2D

func _ready() :
	ghosting()

func set_property(tx_pos, tx_scale) :
	position = tx_pos
	scale = tx_scale
	
func ghosting() :
	var tweenFade = get_tree().create_tween()
	
	tweenFade.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.75)
	await tweenFade.finished
	
	queue_free()
