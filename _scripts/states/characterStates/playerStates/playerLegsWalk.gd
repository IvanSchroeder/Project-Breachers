class_name PlayerLegsWalk extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isMoving = true
	update_speed_parameters(characterBody.currentMoveSpeed, 1.0)
	characterBody.spriteManager.change_current_animation_legs(animationName, "LegsWalk")

func exit() -> void :
	super.exit()
	
	if characterBody.currentVelocity == Vector2.ZERO :
		characterBody.isMoving = false
	else :
		characterBody.isMoving = true

func update(_delta) -> void :
	match characterBody.walkDirection :
		characterBody.WalkDirection.Forward :
			characterBody.spriteManager.change_current_animation_legs(animationName, "LegsWalk")
			characterBody.spriteManager.rotate_hips(characterBody.targetMoveDir, _delta, false, entityData.hipsRotationSpeed)
		characterBody.WalkDirection.Strafe :
			characterBody.spriteManager.change_current_animation_legs(animationName, "LegsStrafe")
			characterBody.spriteManager.rotate_hips(characterBody.targetLookDir, _delta, false, entityData.hipsRotationSpeed)
		characterBody.WalkDirection.Backwalk :
			characterBody.spriteManager.change_current_animation_legs(animationName, "LegsBackwalk")
			characterBody.spriteManager.rotate_hips(-characterBody.targetMoveDir, _delta, false, entityData.hipsRotationSpeed)
	
	get_move_speed()
	
	if !characterBody.canMove || (characterBody.targetMoveDir == Vector2.ZERO && characterBody.currentVelocity == Vector2.ZERO) :
		stateMachine.change_state(stateMachine.get_state("Idle"))
	elif characterBody.isTryingRunning :
		stateMachine.change_state(stateMachine.get_state("Run"))

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.targetMoveDir * characterBody.currentMoveSpeed,
		entityData.lerpVelocity, entityData.acceleration * _delta)
