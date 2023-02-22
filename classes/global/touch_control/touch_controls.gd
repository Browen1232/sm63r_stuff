extends CanvasLayer

const BUTTON_DIMENSIONS = Vector2(20, 21)
const ANCHOR_DIRECTION_OFFSETS = PackedVector2Array([Vector2(1, -1), Vector2(-1, -1), Vector2(1, 1), Vector2(-1, 1)])
const ANCHOR_PIVOT_OFFSETS = PackedVector2Array([Vector2(0, -1), Vector2(-1, -1), Vector2(0, 0), Vector2(-1, 0)])
const ANCHOR_REVERSE_OFFSETS = [false, true, false, true]
const BUTTON_PREFAB = preload("res://classes/global/touch_control/touch_button.tscn")
const LAYOUT_PRESETS = {
	"new": "u:jump,up/d:dive,down/z:pound,interact#c:fludd/x:spin,skip@l:left/r:right#s:switch_fludd/p:pause@_/s:feedback/_",
	"one-finger": "s:switch_fludd,skip/z:pound,interact/d:down#p:pause@_/l:left/x:spin,skip/r:right/_#d:dive,left/u:jump,left/u:jump,up/u:jump,right/d:dive,right#_/c:fludd,left/c:fludd/c:fludd,right/_@_/s:feedback/_",
	"classic": "z:pound,interact/x:spin,skip/c:fludd#s:switch_fludd/p:pause@l:left/d:down,dive/r:right#_/u:up,jump/_@_/s:feedback/_",
}

var button_scale = _get_button_scale()
var action_presses = {} # Record how many buttons are pressing each action
var anchor_order = [0, 1, 2, 3]
var current_layout = "new"

@onready var anchors = [$AnchorLeft, $AnchorRight, $AnchorLeftUp, $AnchorRightUp]

func _init():
	visible = false


func _ready() -> void:
	select_layout("new")


func _get_button_scale() -> int:
	# We want at most half of the screen to be taken up by the touch buttons.
	# We assume that the touch buttons are arranged in a 3x2 grid in each corner.
	# We need the largest size that a single button should be, such that the layout fits this space.
	#
	# Take the individual size of one button. Multiply it by the number of buttons in a row/column.
	# Multiply that by two, since there are two corners in each axis.
	# Multiply it by the current GUI scale, to account for zoom.
	# Take the full window size, and divide that by two.
	# Divide *that* by the value we found earlier, and floor it. Do that for both X and Y.
	# Take the smaller value of those two. We will use this as the default scale multiplier.
	
	var output = min(
		floor(

		),
		floor(

		)
	)
	return output


func _process(_delta) -> void:

	visible = Singleton.touch_control
	for anchor in anchors:
		anchor.scale = Vector2.ONE * gui_scale * button_scale


func _physics_process(_delta) -> void:
	if Singleton.touch_control:
		for action in action_presses:
			if action_presses[action] > 0:
				if !Input.is_action_pressed(action):
					Input.action_press(action)
			elif Input.is_action_pressed(action):
				Input.action_release(action)


func swap_sides() -> void:
	var tmp = anchor_order[0]
	anchor_order[0] = anchor_order[1]
	anchor_order[1] = tmp
	tmp = anchor_order[2]
	anchor_order[2] = anchor_order[3]
	anchor_order[3] = tmp
	select_layout(current_layout)


func press(action_id: String) -> void:
	action_presses[action_id] += 1


func release(action_id: String) -> void:
	action_presses[action_id] -= 1


func select_layout(id: String) -> void:
	current_layout = id
	_clear_buttons()
	_generate_buttons(LAYOUT_PRESETS[id])


func _clear_buttons() -> void:
	for anchor in anchors:
		for child in anchor.get_children():
			child.queue_free()


func _generate_buttons(pattern: String) -> void:
	var pos_offset = Vector2.ZERO
	var anchor_index = 0
	for corner in pattern.split("@"):
		for row in corner.split("#"):
			var buttons: PackedStringArray = row.split("/")
			if ANCHOR_REVERSE_OFFSETS[anchor_order[anchor_index]]:
				buttons.reverse()
			for button in buttons:
				if button != "_":
					var parts = button.split(":")
					var actions = parts[1].split(",")
					for action in actions:
						if !action_presses.has(action):
							action_presses[action] = 0
					var inst = BUTTON_PREFAB.instantiate()
					inst.id = parts[0]
					inst.actions = actions
					inst.position = (
						# Change the direction that the offset applies in based current corner
						pos_offset * ANCHOR_DIRECTION_OFFSETS[anchor_order[anchor_index]]
						# Offset the button because its pivot is in the top left of its sprite
						+ BUTTON_DIMENSIONS * ANCHOR_PIVOT_OFFSETS[anchor_order[anchor_index]]
					)
					anchors[anchor_order[anchor_index]].add_child(inst)
				pos_offset.x += BUTTON_DIMENSIONS.x
			pos_offset.x = 0
			pos_offset.y += BUTTON_DIMENSIONS.y
		pos_offset.y = 0
		anchor_index += 1

