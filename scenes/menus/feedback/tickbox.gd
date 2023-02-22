extends Control

@onready var sprite = $Sprite2D
var pressed = false


func _on_Button_pressed():
	pressed = !pressed
	if pressed:
		Singleton.get_node("SFX/Confirm").play()
	else:
		Singleton.get_node("SFX/Back").play()
	sprite.playing = pressed
	sprite.frame = 0
