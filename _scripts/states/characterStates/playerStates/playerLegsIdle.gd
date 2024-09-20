class_name PlayerLegsIdle extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isIdle = true
	update_speed_parameters(0.0, 1.0)
	characterBody.spriteManager.change_current_animation_legs(animationName, "LegsIdle")

func exit() -> void :
	super.exit()
	characterBody.isIdle = false

func update(_delta) -> void :
	characterBody.spriteManager.change_current_animation_legs(animationName, "LegsIdle")
	characterBody.spriteManager.rotate_hips(characterBody.targetLookDir, _delta, false, entityData.hipsRotationSpeed)
	characterBody.inputManager.lastInputDir = characterBody.targetLookDir
	characterBody.lastMoveDir = characterBody.inputManager.lastInputDir
	
	if !characterBody.canMove : return
	
	if characterBody.targetMoveDir != Vector2.ZERO :
		stateMachine.change_state(stateMachine.get_state("Walk"))
	elif characterBody.targetMoveDir != Vector2.ZERO && characterBody.isTryingRunning :
		stateMachine.change_state(stateMachine.get_state("Run"))

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.targetMoveDir * characterBody.currentMoveSpeed,
		entityData.lerpVelocity, entityData.decceleration * _delta)
