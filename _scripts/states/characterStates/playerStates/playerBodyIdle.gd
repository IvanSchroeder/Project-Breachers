class_name PlayerBodyIdle extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.spriteManager.change_current_animation_body(animationName, "Idle")
	characterBody.spriteManager.sincronize_frames()

func exit() -> void :
	super.exit()

func update(_delta) -> void :
	characterBody.spriteManager.rotate_body(characterBody.targetLookDir, _delta, false, entityData.bodyRotationSpeed)
	
	if characterBody.isMoving :
		if characterBody.isRunning :
			stateMachine.change_state(stateMachine.get_state("Run"))
		else :
			stateMachine.change_state(stateMachine.get_state("Walk"))
