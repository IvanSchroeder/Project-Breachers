class_name SpriteManager extends Node2D

# Script manages the frames that the animation should play for all the separated sprites at the same time.
# Should separate between base and clothing sprites, and/or between upper and lower levels
# (head-body-arms-hands / hips-legs-feet). Animations normally have 6 frames (0-5).

@onready var bodyAnimPlayer : AnimationPlayer = get_node("BodyAnimationPlayer")
@onready var legsAnimPlayer : AnimationPlayer = get_node("LegsAnimationPlayer")
@export var currentBodyAnimation : String = "Idle"
@export var currentLegsAnimation : String = "Idle"

@onready var spritesContainer : Node2D = get_node("SpritesContainer")

@export var HeadSprite : CharacterPart
@export var BodySprite : CharacterPart
@export var ArmMainSprite : CharacterPart
@export var ArmOffSprite : CharacterPart
@export var HandMainSprite : CharacterPart
@export var HandOffSprite : CharacterPart
@export var HipsSprite : CharacterPart
@export var LegMainSprite : CharacterPart
@export var LegOffSprite : CharacterPart

@export var HaircutSprite : CharacterPart
@export var ShirtSprite : CharacterPart
@export var PantsSprite : CharacterPart
@export var ShoesSprite : CharacterPart

@export var SpritesList : Array[CharacterPart]
#@export var BaseSpritesList : Array[CharacterPart]
#@export var ClothingSpritesList : Array[CharacterPart]
@export var UpperPartsList : Array[CharacterPart]
@export var LowerPartsList : Array[CharacterPart]

@export var bodyFrame : int = 0 :
	set = update_body_frames
@export var legsFrame : int = 0 :
	set = update_legs_frames

#func _ready():
	##var format_message = "Added %s to %s."
	##var actual_message
	##actual_message = format_message % [part, BaseSpritesList]
	#for part in SpritesList :
		#if part.partPosition == part.PartPosition.Upper :
			#UpperPartsList.append(part)
		#else :
			#LowerPartsList.append(part)

func change_current_animation_body(animName : String, animSheet : String) :
	if currentBodyAnimation != animName :
		currentBodyAnimation = animName
		bodyAnimPlayer.play(currentBodyAnimation)
	change_spritesheets(animSheet, UpperPartsList)
	
func change_current_animation_legs(animName : String, animSheet : String) :
	if currentLegsAnimation != animName :
		currentLegsAnimation = animName
		legsAnimPlayer.play(currentLegsAnimation)
	change_spritesheets(animSheet, LowerPartsList)

func change_spritesheets(animSheet : String, list : Array[CharacterPart]) :
	for part : CharacterPart in list :
		part.set_anim_sheet(animSheet)

#func change_legs_spritesheets(animSheet : String) :
	#HipsSprite.set_anim_sheet(animSheet)
	#LegMainSprite.set_anim_sheet(animSheet)
	#LegOffSprite.set_anim_sheet(animSheet)

func update_body_frames(newFrame):
	bodyFrame = newFrame
	if is_inside_tree(): # Needed since initial set is called before _ready
		for part : CharacterPart in UpperPartsList:
			if part.is_visible_in_tree() :
				part._set_frame(bodyFrame)

func update_legs_frames(newFrame):
	legsFrame = newFrame
	if is_inside_tree(): # Needed since initial set is called before _ready
		for part : CharacterPart in LowerPartsList:
			if part.is_visible_in_tree() :
				part._set_frame(legsFrame)

func sincronize_frames(reset : bool = false) -> void :
	if reset :
		bodyFrame = 0
		legsFrame = 0
	else :
		bodyFrame = legsFrame

func set_animation_speed_scale(speed : float = 1.0) :
	bodyAnimPlayer.speed_scale = speed
	legsAnimPlayer.speed_scale = speed

func rotate_body(direction : Vector2, delta : float, instant : bool, speed : float) -> void :
	NodeUtilities.rotate_towards(BodySprite, direction, delta, instant, speed)

func rotate_hips(direction : Vector2, delta : float, instant : bool, speed : float) -> void :
	NodeUtilities.rotate_towards(HipsSprite, direction, delta, instant, speed)
