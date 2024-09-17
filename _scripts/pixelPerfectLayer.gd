class_name PixelPerfectLayer extends CanvasLayer

@export var mainCamera : Camera2D
@export var PPCamera : Camera2D

@export var subViewport : SubViewport

func _ready() -> void :
	await get_tree().process_frame
	
	var pixelPerfectStuff : Array = get_tree().get_nodes_in_group("PP")
	
	for thing in pixelPerfectStuff :
		thing.call_deferred("reparent", subViewport, true)

func _process(_delta: float) -> void :
	if !PPCamera or !mainCamera : return
	
	PPCamera.set_global_transform(mainCamera.get_global_transform())
	
	PPCamera.limit_bottom = mainCamera.limit_bottom
	PPCamera.limit_top = mainCamera.limit_top
	PPCamera.limit_right = mainCamera.limit_right
	PPCamera.limit_left = mainCamera.limit_left
