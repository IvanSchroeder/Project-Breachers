class_name PlayerState extends State

@export var playerData : PlayerData = null

func init(charBody : PlayerBody, stateMach : StateMachine, data : EntityData) -> void :
	super.init(charBody, stateMach, data)

func update_speed_parameters(speed : float = 100.0, animSpeed : float = 1.0) -> void :
	characterBody.currentMoveSpeed = speed
	characterBody.spriteManager.set_animation_speed_scale(animSpeed)
