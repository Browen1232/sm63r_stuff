extends TextureRect

const SCROLL_SPEED = 0.5
var wait = 0.0
var progress = 0.0

@onready var flash = $Flash


func _process(delta):
	var dmod = 60 * delta
	var scale = get_parent().scale
	offset_left -= SCROLL_SPEED * scale.x * dmod


	pivot_offset.y = size.y
	scale = scale
	if wait < 50:
		wait += dmod
	else:
		progress = min(progress + dmod, 98)
		if progress > 68:
			flash.color.a = (1 - (progress - 68) / 30) * 0.25


func ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
