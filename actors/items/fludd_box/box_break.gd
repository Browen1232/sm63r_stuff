extends AnimatedSprite

var first_frame = false

func _ready():
	frame = 0 #needed to prevent desync ickyness


func _process(_delta):
	if animation.begins_with("bounce_"):
		if first_frame && frame >= 0 && frame <= 3:
			first_frame = false
			animation = "open_" + animation.substr(7)
		if frame > 3:
			first_frame = true
	else:
		if first_frame && frame == 0:
			queue_free()
		if frame > 0:
			first_frame = true
