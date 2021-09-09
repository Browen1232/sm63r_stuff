extends KinematicBody2D

onready var player = $"/root/Main/Player"
#onready var lm_counter = player.life_meter_counter
#onready var lm_gui = player.get_child("/Camera2D/GUI/LifeMeter")

var shell = preload("koopa_shell.tscn").instance()
const FLOOR = Vector2(0, -1)
const GRAVITY = 0.17

var vel = Vector2.ZERO
var distance_detector = Vector2()
var speed = 0.9
var init_position = 0

export var direction = 1
#It's supposed to walk from left to right for some certain distance.
#And then... completely change the scene from Koopa to shell itself when stepped on?
#It doesn't really change from shell to Koopa back, it just permanently stays there.
#Start from zero, whenever it turns back after reaching a certain point, reset and start over again.

func _ready():
	 init_position = position

func _physics_process(_delta):
	vel.x = speed * direction
	vel.y += GRAVITY
	var snap
	if !is_on_floor():
		snap = Vector2.ZERO
	else:
		snap = Vector2(0, 4)
	#warning-ignore:RETURN_VALUE_DISCARDED
	move_and_slide_with_snap(vel * 60, snap, Vector2.UP, true)
	#raycast2d is used here to detect if the object collided with a wall
	#to change directions
	if is_on_wall():
		flip_ev()
	
	$Sprite.flip_h = direction == 1
	if position.x - init_position.x > 100 or position.x - init_position.x < -100:
		flip_ev()

func flip_ev():
	direction *= -1
	$RayCast2D.position.x *= -1

func _on_KoopaCollision_body_entered(body):
	if body.global_position.x < global_position.x && body.global_position.y > global_position.y:
		print("collided from left")
		player.take_damage_shove(1, -1)
	elif body.global_position.x > global_position.x && body.global_position.y > global_position.y:
		print("collided from right")
		player.take_damage_shove(1, 1)
	if body.global_position.y < global_position.y && (body.global_position.x < global_position.x || body.global_position.x > global_position.x):
		print("collided from top")
		$Kick.play()
		get_parent().add_child(shell)
		shell.position = position
		queue_free()
