class_name StateMachine extends Node2D

var characterBody : CharacterBody2D
var animPlayer : AnimationPlayer

@export var initialState: State
@export var currentState: State
@export var previousState: State
@export var statesList : Array[State]

func get_state(state : String) -> State :
	var s : State
	
	for states in statesList :
		if states.name == state + "State" :
			s = states
			return s
	
	return null

func init(charBody: CharacterBody2D, anim: AnimationPlayer) -> void :
	characterBody = charBody
	animPlayer = anim
	
	for state in statesList:
		state.init(characterBody, self, characterBody.entityData)
	
	print("Initialized State Machine")

func _ready() -> void:
	for state: State in statesList:
		state.finished.connect(change_state)

	# State machines usually access data from the root node of the scene they're part of: the owner.
	# We wait for the owner to be ready to guarantee all the data and nodes the states may need are available.
	await owner.ready
	#initialize_state(statesList[0])
	initialize_state(initialState)

func _process(delta: float) -> void :
	currentState.update(delta)

func _physics_process(delta: float) -> void :
	currentState.physics_update(delta)

func animation_trigger() -> void :
	currentState.animation_trigger()

func animation_trigger_finish() -> void :
	currentState.animation_trigger_finish()

func initialize_state(startingState : State) -> void :
	initialState = startingState
	previousState = initialState
	currentState = initialState
	currentState.enter(previousState)

#func _transition_to_next_state(targetStatePath: String) -> void :
	#if not has_node(targetStatePath):
		#printerr(owner.name + ": Trying to transition to state " + targetStatePath + " but it does not exist.")
		#return
	#
	#var previousStatePath : String
	#
	#if currentState != null :
		#previousStatePath = currentState.name
		#currentState.exit()
	#else :
		#previousStatePath = ""
	#
	#currentState = get_node(targetStatePath)
	#currentState.enter(previousStatePath)

func change_state(targetState: State = null) -> void :
	if targetState == null:
		printerr(owner.name + ": Trying to transition to state " + targetState.name + " but it does not exist.")
		return
	elif targetState == currentState:
		printerr(owner.name + ": Trying to transition to state " + targetState.name + " but it is the same state.")
		return
	
	previousState = currentState
	currentState.exit()
	currentState = targetState
	currentState.enter(previousState)
