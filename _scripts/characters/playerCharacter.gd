class_name PlayerBody extends CharacterBody2D

enum WalkDirection { Forward, Strafe, Backwalk }

@onready var bodyStateMachine : StateMachine = get_node("BodyStateMachine")
@onready var legsStateMachine : StateMachine = get_node("LegsStateMachine")
@onready var spriteManager : SpriteManager = get_node("SpriteManager")
@onready var bodyAnimPlayer : AnimationPlayer = find_child("BodyAnimationPlayer", true)
@onready var legsAnimPlayer : AnimationPlayer = find_child("LegsAnimationPlayer", true)
@onready var inputManager : InputManager = get_node("InputManager")
@export var entityData : EntityData

@onready var eye1 = find_child("Eye1", true)
@onready var eye2 = find_child("Eye2", true)
@onready var eyeTrail1 : Trail = find_child("EyeTrail1", true)
@onready var eyeTrail2 : Trail = find_child("EyeTrail2", true)

@onready var aimPointer : Line2D = find_child("AimPointer", true)
@onready var lookPointer : Line2D = find_child("LookPointer", true)
@onready var inputPointer : Line2D = find_child("InputPointer", true)
@onready var movePointer : Line2D = find_child("MovePointer", true)
@onready var dotProduct1 : Line2D = find_child("DotProduct1", true)
@onready var dotProduct2 : Line2D = find_child("DotProduct2", true)
@onready var dotProduct3 : Line2D = find_child("DotProduct3", true)
@onready var dotProduct4 : Line2D = find_child("DotProduct4", true)

@export var currentMoveSpeed : float = 0.0
@export var currentVelocity : Vector2 = Vector2.ZERO
@export var walkDirection : WalkDirection = WalkDirection.Forward
@export_range(0.0, 90.0) var strafeAngle : float = 45.0
@export_range(90.0, 180.0) var backwardAngle : float = 135.0
var strafeDotLimit : float = 0.5 :
	set(value) : strafeDotLimit = clamp(value, 0.0, 1.0)
var backwardDotLimit : float = -0.5 :
	set(value) : backwardDotLimit = clamp(value, -1.0, 0.0)
var runDotLimit : float = 0.25 :
	set(value) : runDotLimit = clamp(value, 0.0, 1.0)

var targetMoveDir : Vector2 = Vector2.ZERO
var targetLookDir : Vector2 = Vector2(1.0, 0.0)

var moveDir : Vector2 = Vector2.ZERO
var lastMoveDir : Vector2 = Vector2.ZERO
var lookDir : Vector2 = Vector2(1.0, 0.0)

var dotProduct : float = 1.0
var vecFromAngle1 : Vector2 = Vector2(1.0, 0.0)
var vecFromAngle2 : Vector2 = Vector2(1.0, 0.0)

@export var isIdle : bool = true
@export var isMoving : bool = false
@export var isWalking : bool = false
@export var isTryingWalking : bool = false
@export var canMove : bool = true
@export var canRun : bool = true
@export var isTryingRunning : bool = false
@export var isRunning : bool = false
@export var isStrafing : bool = false
@export var isBackwalking : bool = false
@export var isChangingDirections : bool = false

var animationSpeed : float = 1.0

@export var drawEyes : bool = false
@export var interval : float = 0.01
var timer : float = 0.0

func _ready() -> void :
	bodyStateMachine.init(self, bodyAnimPlayer)
	legsStateMachine.init(self, legsAnimPlayer)

func _process(_delta) -> void :
	dotProduct = inputManager.aimDir.dot(inputManager.lastInputDir)
	if drawEyes : draw_eyes(_delta)
	
	vecFromAngle1 = Vector2.from_angle(deg_to_rad(strafeAngle))
	vecFromAngle2 = Vector2.from_angle(deg_to_rad(backwardAngle))
	strafeDotLimit = vecFromAngle1.dot(Vector2.RIGHT)
	backwardDotLimit = vecFromAngle2.dot(Vector2.RIGHT)
	
	isTryingRunning = inputManager.try_run() && canRun
	isTryingWalking = inputManager.try_walk()
	
	targetMoveDir = inputManager.inputDir
	targetLookDir = inputManager.aimDir
	
	if targetMoveDir != Vector2.ZERO :
		lastMoveDir = moveDir
	
	if dotProduct >= strafeDotLimit :
		walkDirection = WalkDirection.Forward
		isStrafing = false
		isBackwalking = false
	elif dotProduct >= backwardDotLimit :
		walkDirection = WalkDirection.Strafe
		isStrafing = true
		isBackwalking = false
	else :
		walkDirection = WalkDirection.Backwalk
		isStrafing = false
		isBackwalking = true

func _physics_process(_delta) -> void :
	NodeUtilities.rotate_towards(aimPointer, targetLookDir, _delta)
	NodeUtilities.rotate_towards(inputPointer, targetMoveDir, _delta)
	
	#NodeUtilities.rotate_towards(lookPointer, targetLookDir, _delta)
	#NodeUtilities.rotate_towards(movePointer, lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
	
	#NodeUtilities.rotate_towards(dotProduct1, vecFromAngle1, _delta)
	#NodeUtilities.rotate_towards(dotProduct2, vecFromAngle1.reflect(Vector2.RIGHT), _delta)
	#NodeUtilities.rotate_towards(dotProduct3, vecFromAngle2, _delta)
	#NodeUtilities.rotate_towards(dotProduct4, vecFromAngle2.reflect(Vector2.RIGHT), _delta)

func move_character(vel : Vector2, lerpVelocity : bool = false, accelAmount : float = 30.0) :
	if !lerpVelocity :
		currentVelocity = vel
	else :
		currentVelocity = currentVelocity.move_toward(vel, accelAmount)
	
	velocity = currentVelocity
	
	move_and_slide()

func apply_movement(vel : Vector2, amount) -> void :
	vel += amount
	vel = vel.limit_length(currentMoveSpeed)

func apply_friction(vel : Vector2, amount) -> void :
	if vel.length() > amount :
		vel -= velocity.normalized() * amount
	else :
		vel = Vector2.ZERO

func rotate_sprites() :
	pass

func draw_eyes(_delta) -> void:
	timer += _delta
	if (timer >= interval) :
		eyeTrail1._draw_points(eye1)
		eyeTrail2._draw_points(eye2)
		timer = 0.0
