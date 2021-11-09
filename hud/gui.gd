extends CanvasLayer

#var font_red = BitmapFont.new()

#absolute cache
onready var singleton = $"/root/Singleton"
onready var player = $"/root/Main/Player"

#misc cache
onready var dialog_box = $DialogBox

#hud cache
onready var coin_counter = $StatsTL/CoinRow/Count
onready var red_coin_counter = $StatsTL/RedCoinRow/Count
onready var life_meter = $LifeMeter
onready var water_meter = $MeterControl
onready var icon = $MeterControl/WaterMeter/Icon
onready var stats_tl = $StatsTL
onready var stats_tr = $StatsTR
onready var stats_bl = $StatsBL
onready var mobile_arrows = $MobileControls/MobileArrows
onready var mobile_action = $MobileControls/MobileAction

#pause cache
onready var bg = $BG
onready var top = $Top
onready var left_corner_top = $LeftCornerTop
onready var left_corner_bottom = $LeftCornerBottom
onready var right_corner_top = $RightCornerTop
onready var right_corner_bottom = $RightCornerBottom
onready var left = $Left
onready var right = $Right
onready var button_map = $ButtonMap
onready var button_map_off = $ButtonMap/StarsOff
onready var button_map_on = $ButtonMap/StarsOn
onready var button_fludd = $ButtonFludd
onready var button_fludd_off = $ButtonFludd/StarsOff
onready var button_fludd_on = $ButtonFludd/StarsOn
onready var button_options = $ButtonOptions
onready var button_options_off = $ButtonOptions/StarsOff
onready var button_options_on = $ButtonOptions/StarsOn
onready var button_exit = $ButtonExit
onready var button_exit_off = $ButtonExit/StarsOff
onready var button_exit_on = $ButtonExit/StarsOn

onready var pause_content = $PauseContent

onready var warp = $"/root/Singleton/Warp"

var pause_offset = 0
var pulse = 0

func _ready():
	coin_counter.text = str(singleton.coin_total)
	set_size(floor(log(floor(OS.window_size.x / 448)) / log(2) + 1), floor(OS.window_size.x / 448))
	var menu = get_tree().get_nodes_in_group("pause")
	for node in menu: #make pause nodes visible but transparent
		node.modulate.a = 0
		node.visible = true


func resize():
	var scale = floor(OS.window_size.y / 304)
	var topsize = OS.window_size.x / scale - 36 - 30
	var offset = 38 / 2 - floor((int(topsize) % 38) / 2.0)
	bg.rect_size = OS.window_size
	
	mobile_arrows.rect_scale = Vector2.ONE * scale * 6
	mobile_action.rect_scale = Vector2.ONE * scale * 6
	
	top.rect_scale = Vector2.ONE * scale
	top.rect_size.x = topsize + offset + 19 * scale
	top.rect_position.x = 29 * scale - offset * scale - 19 * scale
	left_corner_top.rect_scale = Vector2.ONE * scale
	left_corner_bottom.rect_scale = Vector2.ONE * scale
	right_corner_top.rect_scale = Vector2.ONE * scale
	right_corner_bottom.rect_scale = Vector2.ONE * scale
	left.rect_scale = Vector2.ONE * scale
	left.rect_position.y = 17 * scale
	left.rect_size.y = OS.window_size.y / scale - 17 - 33
	right.rect_scale = Vector2.ONE * scale
	right.rect_position.y = 17 * scale
	right.rect_size.y = OS.window_size.y / scale - 17 - 33
	
	button_map.rect_scale = Vector2.ONE * scale
	button_map.rect_position.x = 29 * scale
	button_map.rect_size.x = floor((OS.window_size.x - 61 * scale) / scale / 4)
	button_map_off.polygon[1].x = button_map.rect_size.x - 1
	button_map_off.polygon[2].x = button_map.rect_size.x - 1
	button_map_on.polygon = button_map_off.polygon
	
	button_fludd.rect_scale = Vector2.ONE * scale
	button_fludd.rect_position.x = button_map.rect_position.x + button_map.rect_size.x * scale - 1 * scale
	button_fludd.rect_size.x = ceil((OS.window_size.x - 61 * scale) / scale / 4)
	button_fludd_off.polygon[1].x = button_fludd.rect_size.x - 1
	button_fludd_off.polygon[2].x = button_fludd.rect_size.x - 1
	button_fludd_on.polygon = button_fludd_off.polygon
	
	button_options.rect_scale = Vector2.ONE * scale
	button_options.rect_position.x = button_fludd.rect_position.x + button_fludd.rect_size.x * scale - 1 * scale
	button_options.rect_size.x = floor((OS.window_size.x - 61 * scale) / scale / 4)
	button_options_off.polygon[1].x = button_options.rect_size.x - 1
	button_options_off.polygon[2].x = button_options.rect_size.x - 1
	button_options_on.polygon = button_options_off.polygon
	
	button_exit.rect_scale = Vector2.ONE * scale
	button_exit.rect_position.x = button_options.rect_position.x + button_options.rect_size.x * scale - 1 * scale
	button_exit.rect_size.x = floor((OS.window_size.x - 61 * scale) / scale / 4)
	button_exit_off.polygon[1].x = button_exit.rect_size.x - 1
	button_exit_off.polygon[2].x = button_exit.rect_size.x - 1
	button_exit_on.polygon = button_exit_off.polygon
	
	pause_content.resize(scale)


func set_size(size, lin_size):
	#size: general size of UI elements
	#lin_size: linear size (used for elements that look strange when too small, such as the dialog box)
	water_meter.rect_scale = Vector2.ONE * size
	stats_tl.rect_scale = Vector2.ONE * size
	stats_tr.rect_scale = Vector2.ONE * size
	stats_bl.rect_scale = Vector2.ONE * size
	life_meter.scale = Vector2.ONE * size
	life_meter.position.x = OS.window_size.x / 2
	dialog_box.gui_size = lin_size
#	$InputDisplay.rect_scale = Vector2.ONE * size
#	$InputDisplay.rect_position = Vector2(2 * size, 71 * size)
	resize()


func _process(_delta):
	pulse += 0.1
	$PauseContent/LevelInfo/CollectRow/ShineRow/Shine1/Sprite.material.set_shader_param("outline_color", Color(1, 1, 1, sin(pulse) * 0.25 + 0.5))
	coin_counter.material.set_shader_param("flash_factor", max(coin_counter.material.get_shader_param("flash_factor") - 0.1, 0))
	if coin_counter.text != str(singleton.coin_total):
		coin_counter.material.set_shader_param("flash_factor", 0.5)
		coin_counter.text = str(singleton.coin_total)
		
	red_coin_counter.material.set_shader_param("flash_factor", max(red_coin_counter.material.get_shader_param("flash_factor") - 0.1, 0))
	if red_coin_counter.text != str(singleton.red_coin_total):
		red_coin_counter.material.set_shader_param("flash_factor", 0.5)
		red_coin_counter.text = str(singleton.red_coin_total)
	
	var size_changed = false
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		size_changed = true
	if Input.is_action_just_pressed("screen+") && OS.window_size.x + 448 <= OS.get_screen_size().x && OS.window_size.y + 304 <= OS.get_screen_size().y:
		OS.window_size.x += 448
		OS.window_size.y += 304
		size_changed = true
	if Input.is_action_just_pressed("screen-") && OS.window_size.x - 448 >= 448:
		OS.window_size.x -= 448
		OS.window_size.y -= 304
		size_changed = true
	if size_changed:
		$"/root/Main/Bubbles".refresh()
		set_size(floor(log(floor(OS.window_size.x / 448)) / log(2) + 1), floor(OS.window_size.x / 448))
	
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	
	var menu = get_tree().get_nodes_in_group("pause")
	var gui_scale = floor(OS.window_size.y / 304)
	if get_tree().paused:
		pause_offset = lerp(pause_offset, 1, 0.5)
		for node in menu:
			node.modulate.a = min(node.modulate.a + 0.2, 1)
	else:
		pause_offset = lerp(pause_offset, 0, 0.5)
		for node in menu:
			node.modulate.a = max(node.modulate.a - 0.2, 0)
	stats_tl.margin_left = 8 + (37 * gui_scale) * pause_offset
	stats_tl.margin_top = 8 + (19 * gui_scale) * pause_offset
	stats_tr.margin_left = -8 - (37 * gui_scale) * pause_offset
	stats_tr.margin_top = 8 + (19 * gui_scale) * pause_offset
	stats_bl.margin_left = 8 + (37 * gui_scale) * pause_offset
	stats_bl.margin_top = -8 - (33 * gui_scale) * pause_offset
	water_meter.margin_left = -57 - (37 * gui_scale) * pause_offset
	water_meter.margin_top = -113 - (33 * gui_scale) * pause_offset


func _on_ButtonMap_button_down():
	pass # Replace with function body.


func _on_ButtonFludd_button_down():
	pass # Replace with function body.


func _on_ButtonOptions_button_down():
	pass # Replace with function body.


func _on_ButtonExit_button_down():
	pass # Replace with function body.
