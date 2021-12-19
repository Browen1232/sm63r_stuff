extends Polygon2D

var curve = Curve2D.new()
var curve_top = Vector2.ZERO
var curve_arc = Vector2(0, OS.window_size.y / 2)
var curve_bottom = Vector2(0, OS.window_size.y)
var direction = 0
var enter = 0
var set_location = null
var scene_path = ""
var flip = false

func _ready():
	curve.add_point(Vector2(0, 0))
	curve.add_point(Vector2(0, OS.window_size.y))
	polygon = PoolVector2Array([Vector2(0, 0), Vector2(0, OS.window_size.y / 2), Vector2(0, OS.window_size.y), Vector2(0, OS.window_size.y), Vector2(0, 0)])


func warp(dir, location, path):
	$"/root/Main/Player/Camera2D".drag_margin_h_enabled = true #hack solution to stop camera
	$"/root/Main/Player/Camera2D".drag_margin_v_enabled = true
	enter = 1
	direction = dir
	Singleton.set_location = location
	scene_path = path
	var pos
	if direction.y == 0:
		pos = (1 - direction.x) * OS.window_size.x / 2
		curve_top = Vector2(pos, 0)
		curve_arc = Vector2(0, OS.window_size.y / 2)
		curve_bottom = Vector2(pos, OS.window_size.y)
	else:
		pos = (1 - direction.y) * OS.window_size.y / 2
		curve_top = Vector2(0, pos)
		curve_arc = Vector2(OS.window_size.x / 2, 0)
		curve_bottom = Vector2(OS.window_size.x, pos)


func _process(_delta):
	if enter != 0:
		visible = true
		var speed
		if direction.x == 0:
			speed = OS.window_size.y / Singleton.DEFAULT_SIZE.y
		else:
			speed = OS.window_size.x / Singleton.DEFAULT_SIZE.x
		curve_top += 20 * direction * speed
		curve_arc -= 5 * direction * enter * speed
		curve_bottom += 20 * direction * speed
		curve.set_point_position(0, curve_top)
		curve.set_point_out(0, curve_arc)
		curve.set_point_position(1, curve_bottom)
		
		if direction.x == 0:
			if direction.y * enter == -1:
				polygon = PoolVector2Array([Vector2(0, OS.window_size.y)] + Array(curve.get_baked_points()) + [Vector2(OS.window_size.x, OS.window_size.y)])
			else:
				polygon = PoolVector2Array([Vector2(0, 0)] + Array(curve.get_baked_points()) + [Vector2(OS.window_size.x, 0)])
		else:
			if direction.x * enter == -1:
				polygon = PoolVector2Array([Vector2(OS.window_size.x, 0)] + Array(curve.get_baked_points()) + [Vector2(OS.window_size.x, OS.window_size.y)])
			else:
				polygon = PoolVector2Array([Vector2(0, 0)] + Array(curve.get_baked_points()) + [Vector2(0, OS.window_size.y)])

		if (enter == 1
		&& (
			(curve_top.x + curve_arc.x > OS.window_size.x && direction == Vector2.RIGHT) ||
			(curve_top.x + curve_arc.x < 0 && direction == Vector2.LEFT) ||
			(curve_top.y + curve_arc.y > OS.window_size.y && direction == Vector2.DOWN) ||
			(curve_top.y + curve_arc.y < 0 && direction == Vector2.UP)
			)
			):
			Singleton.warp_to(scene_path)
			curve.clear_points()
			curve.add_point(Vector2(0, 0))
			var pos
			if direction.x == 0:
				curve.add_point(Vector2(0, OS.window_size.y))
				pos = (1 - direction.y) * OS.window_size.y / 2
				curve_top = Vector2(0, pos)
				curve_arc = Vector2(OS.window_size.x / 2, 0)
				curve_bottom = Vector2(OS.window_size.x, pos)
			else:
				curve.add_point(Vector2(OS.window_size.x, 0))
				pos = (1 - direction.x) * OS.window_size.x / 2
				curve_top = Vector2(pos, 0)
				curve_arc = Vector2(0, OS.window_size.y / 2)
				curve_bottom = Vector2(pos, OS.window_size.y)
			
			enter = -1
			Singleton.flip = $"/root/Main/Player/AnimatedSprite".flip_h
		elif enter == -1 && ((curve_top.x > OS.window_size.x && direction == Vector2.RIGHT) || (curve_top.x < 0 && direction == Vector2.LEFT)):
			enter = 0
			visible = false
