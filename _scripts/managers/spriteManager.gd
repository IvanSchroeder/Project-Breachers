class_name SpriteManager extends Node2D

# Script manages the frames that the animation should play for all the separated sprites at the same time.
# Should separate between base and clothing sprites, and/or between upper and lower levels
# (head-body-arms-hands / hips-legs-feet). Animations normally have 6 frames (0-5).

@onready var bodyAnimPlayer : AnimationPlayer = get_node("BodyAnimationPlayer")
@onready var legsAnimPlayer : AnimationPlayer = get_node("LegsAnimationPlayer")
@export var currentBodyAnimation : String = "Idle"
@export var currentLegsAnimation : String = "Idle"

@onready var spritesContainer : Node2D = get_node("SpritesContainer")

# Upper sprites
@export var HeadSprite : CharacterPart
@export var BodySprite : CharacterPart
@export var LeftArmSprite : CharacterPart
@export var RightArmSprite : CharacterPart
@export var LeftHandSprite : CharacterPart
@export var RightHandSprite : CharacterPart

@export var HaircutSprite : CharacterPart
@export var ShirtSprite : CharacterPart
@export var LeftWeaponSprite : CharacterPart
@export var RightWeaponSprite : CharacterPart

# Lower sprites
@export var HipsSprite : CharacterPart
@export var LegsSprite : CharacterPart

@export var PantsSprite : CharacterPart
@export var ShoesSprite : CharacterPart

@onready var SpritesList = spritesContainer.find_children("*Sprite", "CharacterPart", true)
@export var BaseSpritesList : Array[Sprite2D]
@export var ClothingSpritesList : Array[Sprite2D]

@export var bodyFrame : int = 0 :
	set = update_body_frames
@export var legsFrame : int = 0 :
	set = update_legs_frames

@export var bodyAngle : float
@export var hipsAngle : float

func change_current_animation_body(anim : String) :
	currentBodyAnimation = anim
	bodyAnimPlayer.play(currentBodyAnimation)
	change_spritesheets(currentBodyAnimation, CharacterPart.PartPosition.Upper)
	
func change_current_animation_legs(anim : String) :
	currentLegsAnimation = anim
	legsAnimPlayer.play("Legs" + currentLegsAnimation)
	change_spritesheets(currentLegsAnimation, CharacterPart.PartPosition.Lower)

func change_spritesheets(anim : String, part : CharacterPart.PartPosition) :
	for sprite : CharacterPart in SpritesList :
		if sprite.partPosition == part :
			sprite.texture = sprite.get_anim_sheet(anim)

func _ready():
	#find_parts()
	
	#var format_message = "Added %s to %s."
	#var actual_message
	#actual_message = format_message % [part, BaseSpritesList]
	
	for part : CharacterPart in SpritesList:
		if part.partType == part.PartType.Base:
			BaseSpritesList.append(part)
		elif part.partType == part.PartType.Base:
			ClothingSpritesList.append(part)
		
		part.init()

#func find_parts() -> void :
	#HaircutSprite = get_node("HaircutSprite")
	#HeadSprite = get_node("HeadSprite")
	#BodySprite = get_node("BodySprite")
	#LeftArmSprite = get_node("LeftArmSprite")
	#RightArmSprite = get_node("RightArmSprite")
	#LeftHandSprite = get_node("LeftHandSprite")
	#RightHandSprite = get_node("RightHandSprite")
	#HipsSprite = get_node("HipsSprite")
	#LegsSprite = get_node("LegsSprite")
	#
	#ShirtSprite = get_node("ShirtSprite")
	##LeftWeaponSprite = get_node("LeftWeaponSprite")
	##RightWeaponSprite = get_node("RightWeaponSprite")
	#
	#PantsSprite = get_node("PantsSprite")
	#ShoesSprite = get_node("ShoesSprite")

func update_body_frames(newFrame):
	bodyFrame = newFrame
	if is_inside_tree(): # Needed since initial set is called before _ready
		for part : CharacterPart in SpritesList:
			if part.partPosition == part.PartPosition.Upper :
				part._set_frame(bodyFrame)

func update_legs_frames(newFrame):
	legsFrame = newFrame
	if is_inside_tree(): # Needed since initial set is called before _ready
		for part : CharacterPart in SpritesList:
			if part.partPosition == part.PartPosition.Lower :
				part._set_frame(legsFrame)

func rotate_body(direction : Vector2, delta : float, speed : float) -> void :
	NodeUtilities.rotate_towards(BodySprite, direction, delta, false, speed)

func rotate_hips(direction : Vector2, delta : float, speed : float) -> void :
	NodeUtilities.rotate_towards(HipsSprite, direction, delta, false, speed)
