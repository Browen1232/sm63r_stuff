class_name Goomba
extends EntityEnemyTarget

var land_timer = 0

onready var sfx_jump = $SFXJump


func _physics_step():
	if stomped:
		if dead:
			enemy_die()
		else:
			dead = sprite.frame >= 3
	else:
		if !is_on_floor():
			sprite.frame = 1
			sprite.animation = "jumping"
			jump_state = JumpStates.AIRBORNE
		
		if !struck:
			if is_on_floor():
				if jump_state != JumpStates.FLOOR:
					if jump_state != JumpStates.LANDING:
						sprite.frame = 2
						land_timer = 0
						jump_state = JumpStates.LANDING
					
					land_timer += 0.2
					if land_timer >= 1.8:
						sprite.frame = 0
						sprite.animation = "walking"
						jump_state = JumpStates.FLOOR
					else:
						sprite.frame = 2 + land_timer # finish up jumping anim
	
	
	if is_on_floor() && struck && !stomped:
		stomped = true
		sprite.animation = "squish"
		sprite.frame = 0
		sprite.playing = true
	
	_entity_enemy_target_physics_step()


func _wander():
	sprite.speed_scale = 1
	sprite.playing = true
	if mirror:
		vel.x = max(vel.x - 0.1, -1)
	else:
		vel.x = min(vel.x + 0.1, 1)
	wander_dist += 1
	if wander_dist >= 120 && sprite.frame == 0:
		wander_dist = 0
		mirror = !mirror


func _target_alert():
	if is_on_floor():
		sprite.animation = "jumping"
		sfx_jump.play()
		sprite.frame = 0
		jump_state = JumpStates.AIRBORNE
		vel.y = -2.5


func _hurt_stomp(area):
	var body = area.get_parent()
	sprite.animation = "squish"
	struck = false
	vel.y = 0
	sprite.frame = 0
	sprite.playing = true
	if body.state == body.S.DIVE:
		if Input.is_action_pressed("down"):
			_hurt_struck(body)
		else:
			body.start_bounce()
	else:
		body.start_bounce()


func _hurt_struck(body):
	vel.y -= 2.63
	sprite.animation = "jumping"
	jump_state = JumpStates.AIRBORNE
	vel.x = max((12 + abs(vel.x) / 1.5), 0) * 5.4 * sign(position.x - body.position.x) / 10 / 1.5
