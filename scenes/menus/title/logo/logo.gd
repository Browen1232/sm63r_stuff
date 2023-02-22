extends Sprite2D

var progress = 0.0
var wait = 0.0

@onready var flash = $Flash


func _process(delta):
	var dmod = 60 * delta
	scale = get_parent().scale


	if wait < 30:
		wait += dmod
	else:
		progress = min(progress + dmod, 120)
		if progress > 60:
			flash.modulate.a = (1 - (progress - 60) / 60) * 0.75


func ease_out_quart(x: float) -> float:
	return 1 - pow(1 - x, 4)
