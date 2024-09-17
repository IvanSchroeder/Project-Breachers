class_name PlayerBodyIdle extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.spriteManager.change_current_animation_body(animationName)

func exit() -> void :
	super.exit()

func update(_delta) -> void :
	if characterBody.isMoving :
		stateMachine.change_state(stateMachine.get_state("Walk"))
