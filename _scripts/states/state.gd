class_name State extends Node

var characterBody : PlayerBody
var stateMachine : StateMachine
var entityData : EntityData

@export var stateName : String = "State"
@export var animationName : String = "animationState"
var isAnimationFinished : bool = false
var isExitingState : bool = false

var previousState : String

signal finished(next_state_path: String)

func init(charBody : PlayerBody, stateMach : StateMachine, data : EntityData) -> void :
	characterBody = charBody
	stateMachine = stateMach
	entityData = data

func enter(prevState : State) -> void :
	isAnimationFinished = false
	isExitingState = false

func exit() -> void :
	isExitingState = true

func update(_delta: float) -> void :
	if isExitingState: return

func physics_update(_delta: float) -> void :
	if isExitingState: return

func animation_trigger() -> void :
	pass

func animation_trigger_finish() -> void:
	isAnimationFinished = true;
