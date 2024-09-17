class_name PlayerLegsIdle extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isIdle = true
	characterBody.spriteManager.change_current_animation_legs(animationName)

func exit() -> void :
	super.exit()
	characterBody.isIdle = false

func update(_delta) -> void :
	if characterBody.moveDir != Vector2.ZERO :
		stateMachine.change_state(stateMachine.get_state("Walk"))

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.moveDir * 0.0,
		entityData.lerpVelocity, entityData.decceleration * _delta)
