class_name PlayerState extends State

enum WalkDirection { Forward, Backward, Strafing }
@export var walkDirection : WalkDirection = WalkDirection.Forward

@export var playerData : PlayerData = null

func init(charBody : PlayerBody, stateMach : StateMachine, data : EntityData) -> void :
	super.init(charBody, stateMach, data)
