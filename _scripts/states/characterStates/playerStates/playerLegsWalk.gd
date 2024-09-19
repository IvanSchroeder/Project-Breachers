class_name PlayerLegsWalk extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isMoving = true
	update_speed_parameters(0.0, 1.0)
	characterBody.spriteManager.change_current_animation_legs(animationName)

func exit() -> void :
	super.exit()
	characterBody.isMoving = false

func update(_delta) -> void :
	#if characterBody.moveDir == Vector2.ZERO :
		#stateMachine.change_state(stateMachine.get_state("Idle"))
	
	if characterBody.moveDir == Vector2.ZERO && characterBody.currentVelocity == Vector2.ZERO :
		stateMachine.change_state(stateMachine.get_state("Idle"))
	
	if characterBody.dotProduct >= characterBody.strafeDotLimit :
		characterBody.walkDirection = characterBody.WalkDirection.Forward
	elif characterBody.dotProduct >= characterBody.backwardDotLimit :
		characterBody.walkDirection = characterBody.WalkDirection.Strafing
	else :
		characterBody.walkDirection = characterBody.WalkDirection.Backward
	
	if characterBody.isRunning :
		match characterBody.walkDirection :
			characterBody.WalkDirection.Forward :
				characterBody.spriteManager.change_legs_spritesheets("Walk")
				characterBody.spriteManager.rotate_hips(characterBody.lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
			characterBody.WalkDirection.Strafing :
				characterBody.spriteManager.change_legs_spritesheets("Strafe")
				characterBody.spriteManager.rotate_hips(characterBody.inputManager.aimDir, _delta, false, entityData.bodyRotationSpeed)
			characterBody.WalkDirection.Backward :
				characterBody.spriteManager.change_legs_spritesheets("Backward")
				characterBody.spriteManager.rotate_hips(-characterBody.lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
	else :
		match characterBody.walkDirection :
			characterBody.WalkDirection.Forward :
				characterBody.spriteManager.change_legs_spritesheets("Walk")
				characterBody.spriteManager.rotate_hips(characterBody.lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
			characterBody.WalkDirection.Strafing :
				characterBody.spriteManager.change_legs_spritesheets("Strafe")
				characterBody.spriteManager.rotate_hips(characterBody.inputManager.aimDir, _delta, false, entityData.hipsRotationSpeed)
			characterBody.WalkDirection.Backward :
				characterBody.spriteManager.change_legs_spritesheets("Backward")
				characterBody.spriteManager.rotate_hips(-characterBody.lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
	
	get_move_speed()

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.moveDir * characterBody.currentMoveSpeed,
		entityData.lerpVelocity, entityData.acceleration * _delta)

func get_move_speed() :
	if characterBody.isWalking :
		update_speed_parameters(entityData.baseMoveSpeed * entityData.walkSpeedMulti, entityData.walkAnimSpeed)
	elif characterBody.isRunning :
		match characterBody.walkDirection :
				characterBody.WalkDirection.Forward:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.forwardRunSpeedMulti, entityData.runAnimSpeed)
				characterBody.WalkDirection.Strafing:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.strafeRunSpeedMulti, entityData.strafeAnimSpeed)
				characterBody.WalkDirection.Backward:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.backwardRunSpeedMulti, entityData.backwardAnimSpeed)
	elif !entityData.hasDynamicSpeed :
		update_speed_parameters(entityData.baseMoveSpeed, entityData.forwardAnimSpeed)
	else :
		match characterBody.walkDirection :
				characterBody.WalkDirection.Forward:
					update_speed_parameters(entityData.baseMoveSpeed, entityData.forwardAnimSpeed)
				characterBody.WalkDirection.Strafing:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.strafeSpeedMulti, entityData.strafeAnimSpeed)
				characterBody.WalkDirection.Backward:
					update_speed_parameters(entityData.baseMoveSpeed * entityData.backwardSpeedMulti, entityData.backwardAnimSpeed)
