class_name PlayerBodyRun extends PlayerState

func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.spriteManager.change_current_animation_body(animationName, "Run")
	characterBody.spriteManager.sincronize_frames()

func exit() -> void :
	super.exit()

func update(_delta) -> void :
	characterBody.spriteManager.rotate_body(characterBody.targetLookDir, _delta, false, entityData.bodyRotationSpeed)
	
	match characterBody.walkDirection :
		characterBody.WalkDirection.Forward :
			characterBody.spriteManager.change_current_animation_body(animationName, "Run")
		characterBody.WalkDirection.Strafe :
			characterBody.spriteManager.change_current_animation_body(animationName, "Walk")
		characterBody.WalkDirection.Backwalk :
			characterBody.spriteManager.change_current_animation_body(animationName, "Walk")
	
	if characterBody.isIdle :
		stateMachine.change_state(stateMachine.get_state("Idle"))
	elif !characterBody.isRunning :
		stateMachine.change_state(stateMachine.get_state("Walk"))
