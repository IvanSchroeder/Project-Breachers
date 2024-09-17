class_name PlayerLegsWalk extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isMoving = true
	characterBody.spriteManager.change_current_animation_legs(animationName)
	set_animation_speed_scale(1.0)

func exit() -> void :
	super.exit()
	characterBody.isMoving = false

func update(_delta) -> void :
	if characterBody.moveDir == Vector2.ZERO :
		stateMachine.change_state(stateMachine.get_state("Idle"))
	
	if characterBody.dotProduct > 0.25 :
		walkDirection = WalkDirection.Forward
	elif characterBody.dotProduct > -0.25 :
		walkDirection = WalkDirection.Strafing
	else :
		walkDirection = WalkDirection.Backward
	
	get_move_speed()

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.moveDir * characterBody.currentMoveSpeed,
		entityData.lerpVelocity, entityData.acceleration * _delta)

func get_move_speed() :
	if characterBody.isWalking :
		set_animation_speed_scale(0.4)
		characterBody.currentMoveSpeed = entityData.walkSpeed
	elif characterBody.isRunning :
		set_animation_speed_scale(1.5)
		characterBody.currentMoveSpeed = entityData.runSpeed
	elif !entityData.hasDynamicSpeed :
		set_animation_speed_scale(1.0)
		characterBody.currentMoveSpeed = entityData.forwardSpeed
	else :
		match walkDirection :
				WalkDirection.Forward:
					characterBody.canRun = true
					set_animation_speed_scale(1.0)
					characterBody.currentMoveSpeed = entityData.forwardSpeed
				WalkDirection.Strafing:
					characterBody.canRun = false
					set_animation_speed_scale(0.8)
					characterBody.currentMoveSpeed = entityData.strafeSpeed
				WalkDirection.Backward:
					characterBody.canRun = false
					set_animation_speed_scale(0.5)
					characterBody.currentMoveSpeed = entityData.backwardSpeed

func set_animation_speed_scale(speed : float = 1.0) :
	characterBody.bodyAnimPlayer.speed_scale = speed
	characterBody.legsAnimPlayer.speed_scale = speed
