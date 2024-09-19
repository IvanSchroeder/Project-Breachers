class_name CharacterPart extends Sprite2D

enum PartModule {Head, Body, Arm, Hand, Hips, Leg, Foot}
enum PartType {Base, Clothing}
enum PartPosition {Upper, Lower}

@export var displayName : String
@export var defaultTextureSheet : CompressedTexture2D
@export var defaultAnimation : String = "Idle"
@export var defaultColor : Color = Color(255, 255, 255)
@export var partIndex : int = 0
@export var partOrder : int = 1
@export var partModule : PartModule = PartModule.Body
@export var partType : PartType = PartType.Base
@export var partPosition : PartPosition = PartPosition.Upper
@export var parentPart : CharacterPart
@export var hasHitbox : bool = false
@export var hitbox : Area2D

@export var AnimationsList : Dictionary = {
}

@export var currentPlayingAnimation : int

func _ready() :
	init()

func init() -> void :
	texture = get_anim_sheet("Idle")
	z_index = partOrder
	if !hasHitbox :
		hitbox.visible = false

func _set_frame(newFrame: int) -> void :
	if hframes > 1 :
		frame = newFrame
	else :
		frame = 0

func set_anim_sheet(anim : String) -> void :
	texture = get_anim_sheet(anim)

func get_anim_sheet(anim : String) -> CompressedTexture2D :
	if AnimationsList.has(anim) :
		return AnimationsList.get(anim)
	else :
		return defaultTextureSheet
