extends Node


func _process(_delta):
	if Input.is_action_just_pressed("fullscreen") and OS.get_name() != "HTML5":
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED






