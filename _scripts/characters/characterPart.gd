class_name CharacterPart extends Sprite2D

enum PartType {Base, Clothing}
enum PartPosition {Upper, Lower}

@export var displayName : String
@export var partIndex : int = 0
@export var partLevel : int = 0
@export var partType : PartType = PartType.Base
@export var partPosition : PartPosition = PartPosition.Upper
@export var parentPart : CharacterPart
@export var defaultColor : Color = Color(255, 255, 255)

@export var spritesheetsAnimList : Dictionary = {
	"Idle" : preload("res://_art/characterSpritesheets/09_Body_1HandMelee_Idle.png"),
	"Walk" : preload("res://_art/characterSpritesheets/09_Body_1HandMelee_Walk.png"),
}

func init() -> void :
	#self.name = displayName + "Sprite"
	z_index = partLevel

func _set_frame(newFrame: int) -> void :
	frame = newFrame

func get_anim_sheet(animation : String) -> Texture2D :
	return spritesheetsAnimList.get(animation)
