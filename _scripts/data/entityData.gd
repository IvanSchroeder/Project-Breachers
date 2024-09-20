class_name EntityData extends Resource

@export_group("Movement Parameters")
@export var hasDynamicSpeed : bool = true
@export var lerpVelocity : bool = true
@export var maxMoveSpeed : float = 300.0
@export var baseMoveSpeed : float = 150.0
@export var acceleration : float = 150.0
@export var decceleration : float = 200.0
#@export var forwardSpeed : float = 150.0
#@export var strafeSpeed : float = 100.0
#@export var backwardSpeed : float = 75.0
#@export var walkSpeed : float = 50.0
#@export var runSpeed : float = 200.0
@export_range(0.0, 3.0) var strafeSpeedMulti : float = 0.75
@export_range(0.0, 3.0) var backwardSpeedMulti : float = 0.5
@export_range(0.0, 3.0) var walkSpeedMulti : float = 0.33
@export_range(0.0, 3.0) var forwardRunSpeedMulti : float = 2.0
@export_range(0.0, 3.0) var strafeRunSpeedMulti : float = 1.4
@export_range(0.0, 3.0) var backwardRunSpeedMulti : float = 1.2

@export_group("Aim Parameters")
@export var turnSpeed : float = 10
@export var bodyRotationSpeed : float = 20.0
@export var hipsRotationSpeed : float = 20.0

@export_group("Animation Speed Parameters")
@export var forwardAnimSpeed : float = 1.0
@export var strafeAnimSpeed : float = 0.8
@export var backwardAnimSpeed : float = 0.5
@export var walkAnimSpeed : float = 0.4
@export var runAnimSpeed : float = 1.25
