class_name HeightmapGenerator3DSettings
extends GeneratorSettings3D

## Info for the tile that will be placed. Has information about
## it's position in the TileSet.
@export var tile: TileInfo
@export var noise: FastNoiseLite = FastNoiseLite.new()
## Infinite worlds only work with a [ChunkLoader3D].
@export var infinite := false :
	set(value):
		infinite = value
		notify_property_list_changed()
## The size in the x and z axis.
@export var world_size := Vector2i(16, 16)
## The medium height at which the heightmap will start displacing from y=0.
## The heightmap displaces this height by a random number
## between -[param height_intensity] and [param height_intensity].
@export var height_offset := 128
## The heightmap displaces [param height_offset] by a random number
## from -[param height_intensity] to [param height_intensity].
@export var height_intensity := 20
## Negative values means the HeightmapGenerator will go below y=0.
@export var min_height := 0
## If [code]true[/code], adds a layer of air ([code]null[/code] tiles above the generated terrain.
@export var air_layer := true
@export_group("Falloff", "falloff_")
## Enables the usage of a [FalloffMap], which makes tiles
## farther away from the center be lower in the heightmap,
## forming islands. Doesn't work if [param infinite] is [code]true[/code].
@export var falloff_enabled: bool = false
## A [FalloffMap], which makes tiles
## farther away from the center be lower in the heightmap,
## forming islands. Doesn't work if [param infinite] is [code]true[/code].
@export var falloff_map: FalloffMap:
	set(value):
		falloff_map = value
		if falloff_map != null:
			falloff_map.size = world_size


func _validate_property(property: Dictionary) -> void:
	if property.name == "world_size" and infinite == true:
		property.usage = PROPERTY_USAGE_NONE
