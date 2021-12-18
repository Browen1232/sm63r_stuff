extends Node

const DEFAULT_SIZE = Vector2(640, 360)

onready var serializer: Serializer = $Serializer
onready var base_modifier: BaseModifier = $BaseModifier

var classic = true

var nozzle = 0
var water = 100
var power = 100
var coin_total = 0
var internal_coin_counter = 0 #if it hits 5, gets reset
var red_coin_total = 0
var rng = RandomNumberGenerator.new()
var life_meter = 8
var enter = 0
var direction = 0
var dead = false
var hp = 8
var kris = false
var meter_progress = 0
var collected_nozzles = [false, false, false]
var collected_dict = {}
var collect_count = 0
var set_location
var flip

func _ready():
	#create_coindict(get_tree().get_current_scene().get_filename())
	rng.seed = hash("2401")
	collect_count = 0 # reset the collect count on every room load
#	if enter != 0:
#		$"/root/Main/Player/Camera2D/GUI/SweepEffect".enter = enter
#		$"/root/Main/Player/Camera2D/GUI/SweepEffect".enter = direction


func warp_to(path):
	collect_count = 0
	#create_coindict(path)
	#warning-ignore:RETURN_VALUE_DISCARDED
	return get_tree().call_deferred("change_scene", path)


func get_collect_id():
	var path = get_tree().get_current_scene().get_filename()
	create_coindict(path)
	Singleton.collected_dict[path].append(false)
	collect_count += 1
	return collect_count - 1


func create_coindict(path):
	if !collected_dict.has(path):
		collected_dict[path] = [false]
