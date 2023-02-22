class_name Warp
extends Polygon2D

var curve = Curve2D.new()
var curve_top = Vector2.ZERO


var direction = 0
var enter = 0
var set_location = null
var scene_path = ""
var flip = false
var anim_timer = 0


func _ready():
	curve.add_point(Vector2(0, 0))




func warp(dir: Vector2, location: Vector2, path: String):
	var cam_area = $"/root/Main/CameraArea"
	if cam_area != null:
		cam_area.frozen = true
	enter = 1
	direction = dir
	Singleton.warp_location = location
	scene_path = path
	
	var pos
	if direction.y == 0:

		curve_top = Vector2(pos, 0)


	else:

		curve_top = Vector2(0, pos)




func _physics_process(_delta):
	if enter != 0:
		anim_timer += 1
	if (enter == 1 and anim_timer >= 44):
		anim_timer = 0
		
		curve.clear_points()
		curve.add_point(Vector2(0, 0))
		var pos
		if direction.x == 0:


			curve_top = Vector2(0, pos)


		else:


			curve_top = Vector2(pos, 0)


		
		Singleton.warp_to(scene_path, $"/root/Main/Player")
		
		enter = -1
	elif enter == -1 and anim_timer >= 44:
		anim_timer = 0
		enter = 0
		visible = false


func _process(delta):
	var dmod = min(60 * delta, 1)
	if enter != 0:
		visible = true
		var speed
		if direction.x == 0:

		else:

		curve_top += 20 * direction * speed * dmod
		curve_arc -= 5 * direction * enter * speed * dmod
		curve_bottom += 20 * direction * speed * dmod
		curve.set_point_position(0, curve_top)
		curve.set_point_out(0, curve_arc)
		curve.set_point_position(1, curve_bottom)
		if direction.x == 0:
			if direction.y * enter == -1:

			else:

		else:
			if direction.x * enter == -1:

			else:

