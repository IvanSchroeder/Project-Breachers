class_name PlayerBodyWalk extends PlayerState

func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.spriteManager.change_current_animation_body(animationName)

func exit() -> void :
	super.exit()

func update(_delta) -> void :
	if characterBody.isIdle :
		stateMachine.change_state(stateMachine.get_state("Idle"))
