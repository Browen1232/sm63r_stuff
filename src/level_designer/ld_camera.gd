extends Camera2D

signal test_level

onready var LD = get_parent()
onready var map = LD.get_node("TileMap")
onready var music = LD.get_node("Music")

var scroll_speed = 8
var mouse_pos = Vector2(0, 0)
var mouse_pos_store = Vector2(0, 0)
var objects_loaded = {}

const player = preload("res://actors/player/player.tscn")

func _ready():
	position = Vector2(-120, -OS.window_size.y + 60)

func _process(_delta):
	var i_left = Input.is_action_pressed("LD_cam_left")
	var i_right = Input.is_action_pressed("LD_cam_right")
	var i_up = Input.is_action_pressed("LD_cam_up")
	var i_down = Input.is_action_pressed("LD_cam_down")
	var i_pan = Input.is_action_pressed("LD_cam_pan")
	var i_place = Input.is_action_pressed("LD_place")
	var i_delete = Input.is_action_pressed("LD_delete")
	mouse_pos = get_local_mouse_position()
	
	if i_pan:
		position += mouse_pos_store - mouse_pos
	else:
		#Horrific code compression - this is just for moving the camera
		position += Vector2((int(i_right) - int(i_left))*scroll_speed, (int(i_down) - int(i_up))*scroll_speed)
		
	mouse_pos_store = mouse_pos
	
#	if i_place:
#		map.set_cellv(map.world_to_map(get_global_mouse_position()), 0)
#
#	if i_delete:
#		map.set_cellv(map.world_to_map(get_global_mouse_position()), -1)
#
	if i_down && Input.is_action_just_pressed("debug"):
		var player_spawn = player.instance()
		player_spawn.position = get_parent().start_pos
		get_parent().add_child(player_spawn)
		emit_signal("test_level")
		
	if i_right && Input.is_action_pressed("debug"):
		LD.save_code()

func object_load(id):
	if !objects_loaded.has(id):
		objects_loaded[id] = load("res://actors/items/" + str(id) + "/" + str(id) + ".tscn")
	return objects_loaded[id]
