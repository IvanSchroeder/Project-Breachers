class_name NodeUtils extends Node2D

func rotate_towards(node : Node, direction : Vector2, delta : float, instant : bool = true, speed : float = 1000.0) -> void :
	var angle = node.transform.x.angle_to(direction)
	
	if instant :
		node.rotate(sign(angle) * min(delta * 1000.0, abs(angle)))
	else :
		node.rotate(sign(angle) * min(delta * speed, abs(angle)))
	
	if node.rotation_degrees < 0 : node.rotation_degrees = 360.0
	elif node.rotation_degrees > 360.0 : node.rotation_degrees = 0

func rotate_towards_vector(vector : Vector2, direction : Vector2, delta : float, instant : bool = true, speed : float = 1000.0) -> Vector2 :
	var angle = vector.angle_to(direction)
	var rotVec = Vector2.ZERO
	
	if instant :
		rotVec = vector.rotated(sign(angle) * min(delta * 1000.0, abs(angle)))
	else :
		rotVec = vector.rotated(sign(angle) * min(delta * speed, abs(angle)))
	
	return rotVec

## Searches a node's immediate children for the first node of type "type"
##
## Params:
## - node: the node to search from
## - type: the GDscript type to search for (ex. RigidBody2D, CharacterBody2D, Control, etc)
##
## Example Usage:
## 
## @onready var player: Player = get_tree().get_first_node_in_group('player')
## var regen_sec: float = 5
## 
## func _physics_process(delta):
##    # looks for a player's health bar right under the player's root node.
##    var health_bar: HealthBar = N.get_child_immediate(player, HealthBar)
##    if health_bar:
##        health_bar.recover_health(regen_sec*delta)
static func get_immediate_child(node: Node, type):
	if not node: 
		return null

	if is_instance_of(node, type):
		return node
	
	for child in node.get_children():
		if is_instance_of(node, type):
			return node

	return null

# ///////////////////////////////////////////////////////////////////////////////

# https://gist.github.com/DaelonSuzuka/bb303577c7fa1241c352e69554e8d300

func check_extension(file, ext=null) -> bool:
	if ext:
		if ext is String:
			if file.ends_with(ext):
				return true
		elif ext is Array:
			for e in ext:
				if file.ends_with(e):
					return true
	return false

# get all files in given directory with optional extension filter
func get_files(path: String, ext='') -> Array:
	var _files = []

	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	var file = dir.get_next()
	while true:
		var file_path = dir.get_current_dir().path_join(file)
		if file == "":
			break
		if ext:
			if check_extension(file, ext):
				_files.append(file_path)
		else:
			_files.append(file_path)
		file = dir.get_next()

	dir.list_dir_end()

	return _files

# get all files in given directory(and subdirectories, to a given depth) with optional extension filter
func get_all_files(path: String, ext='', max_depth:=10, _depth:=0, _files:=[]) -> Array:
	if _depth >= max_depth:
		return []

	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	var file = dir.get_next()
	while file != '':
		var file_path = dir.get_current_dir().path_join(file)
		if dir.current_is_dir():
			get_all_files(file_path, ext, max_depth, _depth + 1, _files)
		else:
			if ext:
				if check_extension(file, ext):
					_files.append(file_path)
			else:
				_files.append(file_path)
		file = dir.get_next()
	dir.list_dir_end()
	return _files

# get all files AND folders in a given directory(and subdirectories, to a given depth)
func get_all_files_and_folders(path: String, max_depth:=10, _depth:=0, _files:=[]) -> Array:
	if _depth >= max_depth:
		return []

	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	var file = dir.get_next()
	while file != '':
		var file_path = dir.get_current_dir().path_join(file)
		_files.append(file_path)
		if dir.current_is_dir():
			get_all_files_and_folders(file_path, max_depth, _depth + 1, _files)
		file = dir.get_next()
	dir.list_dir_end()
	return _files

# get all folders in a given directory(and subdirectories, to a given depth)
func get_all_folders(path: String, max_depth:=10, _depth:=0, _files:=[]) -> Array:
	if _depth >= max_depth:
		return []

	var dir = DirAccess.open(path)
	dir.list_dir_begin()

	var file = dir.get_next()
	while file != '':
		var file_path = dir.get_current_dir().path_join(file)
		if dir.current_is_dir():
			_files.append(file_path)
			get_all_folders(file_path, max_depth, _depth + 1, _files)
		file = dir.get_next()
	dir.list_dir_end()
	return _files

# ------------------------------------------------------------------------------

var file_prefix: String

func _ready():
	if OS.has_feature("standalone"):
		file_prefix = 'user://'
	else:
		file_prefix = 'res://data/'

func _ensure_prefix(path:String, prefix:=file_prefix) -> String:
	if !path.begins_with(prefix):
		path = prefix + path
	return path

func _ensure_suffix(path:String, suffix:='.json') -> String:
	if !path.ends_with(suffix):
		path += suffix
	return path

func _ensure_directory(path:String) -> void:
	if !DirAccess.dir_exists_absolute(path):
		DirAccess.make_dir_recursive_absolute(path)

# ------------------------------------------------------------------------------

func save_json(file_name: String, data, auto_prefix:=true) -> void:
	if auto_prefix:
		file_name = _ensure_prefix(file_name)

	file_name = _ensure_suffix(file_name)

	_ensure_directory(file_name.get_base_dir())

	var f = FileAccess.open(file_name, FileAccess.WRITE)
	f.store_string(JSON.stringify(data, "\t", false))
	f = null

func load_json(file_name: String, default=null, auto_prefix:=true):
	var result = default

	if auto_prefix:
		file_name = _ensure_prefix(file_name)

	file_name = _ensure_suffix(file_name)

	if FileAccess.file_exists(file_name):
		var f = FileAccess.open(file_name, FileAccess.READ)
		var text = f.get_as_text()
		f = null
		var json = JSON.parse_string(text)
		if json:
			result = json
	return result

# ///////////////////////////////////////////////////////////////////////////////

# https://www.reddit.com/r/godot/comments/18bb7hj/useful_gdscript_functions/

func new_timer_timeout(parent_node: Node, time: float) -> Signal:
	var timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(timer.queue_free)
	parent_node.add_child(timer)
	timer.start(time)
	return timer.timeout

# await Autoload.new_timer_timeout(self, 1.5)

func volume_percent_to_db(volume : float) -> float:  
	return log(max(volume, 0.0) * 0.01) * 17.3123

func volume_to_db(volume : float) -> float:
	return log(max(volume, 0.0)) * 17.3123 

static func repeat(t, length):  
	return t - floor(t / length) * length  
static func repeat_int(t:int, length:int) -> int:  
	return t - floori(t / float(length)) * length  
static func repeat_float(t:float, length:float) -> float:  
	return t - floorf(t / length) * length
