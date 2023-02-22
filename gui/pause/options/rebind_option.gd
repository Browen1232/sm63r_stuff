extends Button

const ACTION_MAP = {
	"left":"Left",
	"right":"Right",
	"jump":"Jump",
	"dive":"Dive",
	"spin":"Spin",
	"pound":"Ground Pound",
	"fludd":"Use FLUDD",
	"switch_fludd":"Switch FLUDD Nozzle",
	"pause":"Pause",
	"interact":"Interact",
	"skip":"Skip Text",
	"zoom+":"Zoom In",
	"zoom-":"Zoom Out",
	"semi":"Power Swim",
	"reset":"Reset Run",
	"timer_show":"Show Timer",
	"mute_music":"Mute Music",
	"mute_sfx":"Mute SFX",
	"volume_music+":"Music Volume +",
	"volume_music-":"Music Volume -",
	"volume_sfx+":"SFX Volume +",
	"volume_sfx-":"SFX Volume -",
	"fullscreen":"Fullscreen",
	"screen+":"Screen Size +",
	"screen-":"Screen Size -",
	"feedback":"Open Feedback Menu",
	"debug":"Open Debug Console",
}

const JOYPAD_BUTTONS = [
	["(B)", "(A)", "(X)"],
	["(A)", "(B)", "(O)"],
	["(Y)", "(X)", "([])"],
	["(X)", "(Y)", "(/\\)"],
	["(L)", "(LB)", "(L1)"],
	["(R)", "(RB)", "(R1)"],
	["(-)", "(Back)", "(Select)"],
	["(+)", "(Start)", "(Start)"],
	["(Left Stick Click)", "(Left Stick Click)", "(Left Stick Click)"],
	["(Right Stick Click)", "(Right Stick Click)", "(Right Stick Click)"],
	["(ZL)", "(LT)", "(L2)"],
	["(ZR)", "(RT)", "(R2)"],
	["(Logo)", "(Logo)", "(Logo)"],
	["(D-Up)", "(D-Up)", "(D-Up)"],
	["(D-Down)", "(D-Down)", "(D-Down)"],
	["(D-Left)", "(D-Left)", "(D-Left)"],
	["(D-Right)", "(D-Right)", "(D-Right)"],
]

@export var action_id: String = ""

@onready var key_list = $KeyList
@onready var action_name = $ActionName
var scale: float : set = set_scale


func _ready():
	action_name.text = ACTION_MAP[action_id]
	update_list()


func _input(event):
	if pressed:
		if event is InputEventKey or event is InputEventJoypadButton or (event is InputEventJoypadMotion and abs(event.axis_value) > 0.25):
			Singleton.get_node("SFX/Confirm").play()
			InputMap.action_add_event(action_id, event)
			unpress()
			Singleton.save_input_map(Singleton.get_input_map_json_current())
			update_list()


func update_list():
	key_list.text = join_action_array(InputMap.action_get_events(action_id))


func join_action_array(actions) -> String:
	var output: String = ""
	for action in actions:
		if action is InputEventJoypadButton:
			if action.button_index > JOYPAD_BUTTONS.size():
				output += "(?)"
			else:
				output += JOYPAD_BUTTONS[action.button_index][get_brand_id()]
		elif action is InputEventJoypadMotion:
			output += get_joypad_motion_name(action.axis, action.axis_value)
		else:
			output += action.as_text()
		output += ", "
	output = output.trim_suffix(", ")
	return output


func _on_RebindOption_pressed():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Singleton.get_node("SFX/Back").play()
		InputMap.action_erase_events(action_id)
		Singleton.save_input_map(Singleton.get_input_map_json_current())
		update_list()
	else:
		Singleton.get_node("SFX/Next").play()
		action_name.add_theme_color_override("font_color", Color.GREEN)
		key_list.add_theme_color_override("font_color", Color.GREEN)
		

func get_brand_id(): # need to get the gamepad brand so we can display correct button icons
	if Input.get_connected_joypads().size() > 0:
		var guid = Input.get_joy_guid(0)
		var vendor_id = guid.substr(8, 4)
		match vendor_id:
			"7e05": # nintendo
				return 0
			"5e04": # microsoft
				return 1
			"1716", "7264", "4c05", "510a", "ce0f", "ba12": # sony
				return 2
			_:
				return 0
	else:
		return 0


func _on_RebindOption_mouse_entered():
	if !pressed:
		action_name.add_theme_color_override("font_color", Color.AQUA)
		key_list.add_theme_color_override("font_color", Color.AQUA)


func _on_RebindOption_mouse_exited():
	if !pressed:
		action_name.add_theme_color_override("font_color", Color.WHITE)
		key_list.add_theme_color_override("font_color", Color.WHITE)


func unpress():
	pressed = false
	action_name.add_theme_color_override("font_color", Color.WHITE)
	key_list.add_theme_color_override("font_color", Color.WHITE)


func get_joypad_motion_name(axis: int, value: float):
	match axis:
		JOY_AXIS_0:
			return "(Left Stick Left)" if value < 0 else "(Left Stick Right)"
		JOY_AXIS_1:
			return "(Left Stick Up)" if value < 0 else "(Left Stick Down)"
		JOY_AXIS_2:
			return "(Right Stick Left)" if value < 0 else "(Right Stick Right)"
		JOY_AXIS_3:
			return "(Right Stick Up)" if value < 0 else "(Right Stick Down)"


func set_scale(new_scale):
	scale = new_scale
	action_name.scale = Vector2.ONE * new_scale
	key_list.scale = Vector2.ONE * new_scale
	key_list.pivot_offset.x = key_list.size.x


func _process(_delta):
	update_list()
