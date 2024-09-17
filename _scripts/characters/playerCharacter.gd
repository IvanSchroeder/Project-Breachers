class_name PlayerBody extends CharacterBody2D

enum WalkDirection { Forward, Backward, Strafing }

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

@export var currentMoveSpeed : float = 0.0
@export var currentVelocity : Vector2 = Vector2.ZERO
var moveDir : Vector2 = Vector2.ZERO
var lastMoveDir : Vector2 = Vector2(1.0, 0.0)
var dotProduct : float = 1.0

@export var isIdle : bool = true
@export var isMoving : bool = false
@export var isWalking : bool = false
@export var canRun : bool = true
@export var isRunning : bool = false
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
	
	moveDir = inputManager.inputDir
	
	if moveDir != Vector2.ZERO :
		lastMoveDir = moveDir
	
	isRunning = canRun && inputManager.try_run()
	isWalking = inputManager.try_walk()

func _physics_process(_delta) -> void :
	NodeUtilities.rotate_towards(aimPointer, inputManager.aimDir, _delta)
	NodeUtilities.rotate_towards(inputPointer, inputManager.lastInputDir, _delta)
	
	NodeUtilities.rotate_towards(lookPointer, inputManager.aimDir, _delta, false, entityData.bodyRotationSpeed)
	NodeUtilities.rotate_towards(movePointer, lastMoveDir, _delta, false, entityData.hipsRotationSpeed)
	
	if isIdle && dotProduct < 0.0 :
		spriteManager.rotate_hips(inputManager.aimDir, _delta, entityData.hipsRotationSpeed)
		inputManager.lastInputDir = inputManager.aimDir
		lastMoveDir = inputManager.aimDir
	elif isRunning :
		spriteManager.rotate_body(lastMoveDir, _delta, entityData.bodyRotationSpeed)
		spriteManager.rotate_hips(lastMoveDir, _delta, entityData.hipsRotationSpeed)
	else :
		spriteManager.rotate_body(inputManager.aimDir, _delta, entityData.bodyRotationSpeed)
		
		if dotProduct >= 0.0 :
			spriteManager.rotate_hips(lastMoveDir, _delta, entityData.hipsRotationSpeed)
		else :
			spriteManager.rotate_hips(inputManager.aimDir, _delta, entityData.hipsRotationSpeed)

func move_character(vel : Vector2, lerpVelocity : bool = false, accelAmount : float = 30.0) :
	if !lerpVelocity :
		currentVelocity = vel
	else :
		#if currentVelocity.normalized() > vel.normalized() :
			#apply_friction(currentVelocity, accelAmount)
		#else :
			#apply_movement(currentVelocity, lastMoveDir * accelAmount)
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
