extends Sprite2D

var progress = 0.5
var season_progress = 0


func _process(delta):
	var dmod = 60 * delta
	var scalar = get_parent().scale
	scale = scalar * Vector2.ONE
	progress += (1.0 / 60.0) / 10 * dmod
	if progress >= 1.5:
		season_progress = (season_progress + 1) % 9
		progress = 0


