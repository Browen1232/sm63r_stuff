extends Control

@onready var parent = $".."

func _init():
	visible = false


func _ready():



func _process(_delta):
	visible = Singleton.touch_control


func _on_Unpause_pressed():
	if !Singleton.meta_pauses["feedback"] and parent.modulate.a >= 1:
		Input.action_press("pause")


func _on_Unpause_released():
	if !Singleton.meta_pauses["feedback"] and parent.modulate.a >= 1:
		Input.action_release("pause")
