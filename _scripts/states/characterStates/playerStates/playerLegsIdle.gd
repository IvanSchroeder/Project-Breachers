class_name PlayerLegsIdle extends PlayerState
 
func enter(prevState: State) -> void :
	super.enter(prevState)
	characterBody.isIdle = true
	update_speed_parameters(0.0, 1.0)
	characterBody.spriteManager.change_current_animation_legs(animationName)
	characterBody.spriteManager.change_legs_spritesheets("Idle")

func exit() -> void :
	super.exit()
	characterBody.isIdle = false

func update(_delta) -> void :
	
	characterBody.spriteManager.change_legs_spritesheets("Idle")
	characterBody.spriteManager.rotate_hips(characterBody.inputManager.aimDir, _delta, false, entityData.hipsRotationSpeed)
	characterBody.inputManager.lastInputDir = characterBody.inputManager.aimDir
	characterBody.lastMoveDir = characterBody.inputManager.lastInputDir
	
	if characterBody.moveDir != Vector2.ZERO :
		stateMachine.change_state(stateMachine.get_state("Walk"))

func physics_update(_delta) -> void :
	characterBody.move_character(characterBody.moveDir * 0.0,
		entityData.lerpVelocity, entityData.decceleration * _delta)
