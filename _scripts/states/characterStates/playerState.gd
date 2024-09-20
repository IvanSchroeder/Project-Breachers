class_name PlayerState extends State

@export var playerData : PlayerData = null

func init(charBody : PlayerBody, stateMach : StateMachine, data : EntityData) -> void :
	super.init(charBody, stateMach, data)

func update_speed_parameters(speed : float = 120.0, animSpeed : float = 1.0) -> void :
	characterBody.currentMoveSpeed = speed
	characterBody.spriteManager.set_animation_speed_scale(animSpeed)

func get_move_speed() :
	if characterBody.isWalking :
		update_speed_parameters(entityData.baseMoveSpeed * entityData.walkSpeedMulti, entityData.walkAnimSpeed)
	elif characterBody.isRunning :
		match characterBody.walkDirection :
				characterBody.WalkDirection.Forward:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.forwardRunSpeedMulti, entityData.runAnimSpeed)
				characterBody.WalkDirection.Strafe:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.strafeRunSpeedMulti, entityData.strafeAnimSpeed)
				characterBody.WalkDirection.Backwalk:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.backwardRunSpeedMulti, entityData.backwardAnimSpeed)
	elif !entityData.hasDynamicSpeed :
		update_speed_parameters(entityData.baseMoveSpeed, entityData.forwardAnimSpeed)
	else :
		match characterBody.walkDirection :
				characterBody.WalkDirection.Forward:
					update_speed_parameters(entityData.baseMoveSpeed, entityData.forwardAnimSpeed)
				characterBody.WalkDirection.Strafe:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.strafeSpeedMulti, entityData.strafeAnimSpeed)
				characterBody.WalkDirection.Backwalk:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.backwardSpeedMulti, entityData.backwardAnimSpeed)
