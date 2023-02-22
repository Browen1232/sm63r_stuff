extends Control

var req = HTTPRequest.new()

func _ready():
	visible = false
	add_child(req)

func _process(_delta):

	scale = Vector2.ONE * Singleton.get_screen_scale()
	if Input.is_action_just_pressed("feedback"):
		visible = !visible
		get_tree().paused = visible or Singleton.pause_menu
		Singleton.set_pause("feedback", visible)


func add_data(tag: String, data) -> String:
	return tag + ":" + str(data) + "\n"


func _on_Submit_pressed():
	var desc = $Panel/TextEdit.text
	if desc == "":
		Singleton.get_node("SFX/Back").play()
	else:
		visible = false
		if !Singleton.pause_menu:
			get_tree().paused = false
		var msg = "**Description:**\n> "
		msg += desc
		
		msg += "\n**Categories:**"
		var categories = ""
		for check in $Checkboxes.get_children():
			if check.pressed:
				categories += "\n> " + check.get_name()
		if categories == "":
			categories = "\n> `none`"
		msg += categories
		
		msg += "\n**Mood:**\n> "
		var mood_emote = "`none`"
		for mood in $Traffic.get_children():
			if mood.pressed:
				match mood.get_name():
					"Negative":
						mood_emote = ":blue_square: Negative"
					"Neutral":
						mood_emote = ":yellow_square: Neutral"
					"Positive":
						mood_emote = ":green_square: Positive"
		msg += mood_emote
		
		var username
		var contact = $Panel2/LineEdit.text
		if contact == "":
			username = "Feedback [unnamed]"
			contact = "`none`"
		else:
			username = "Feedback [%s]" % contact
		
		msg += "\n**Contact:**\n> " + contact

		var data = assemble_package()
		
		await RenderingServer.frame_post_draw
		var img = get_viewport().get_texture().get_data()
		img.flip_y()
		img = img.save_png_to_buffer()
		var payload = ("--boundary\nContent-Disposition:form-data; name=\"content\"\n\n"
		+ msg
		+ "\n--boundary\nContent-Disposition:form-data; name=\"username\"\n\n"
		+ username
		+ "\n--boundary\nContent-Disposition: form-data; name=\"files[0]\"; filename=\"data.txt\"\nContent-Type: text/plain\n\n"
		+ data
		+ "\n--boundary\nContent-Disposition: form-data; name=\"files[1]\"; filename=\"screenshot.png\"\nContent-Type: image/png\n\n").to_utf8_buffer()
		payload.append_array(img)
		payload.append_array("\n--boundary--".to_utf8_buffer())
		#req.connect("request_completed",Callable(self,"_on_request_completed"))
		req.request_raw(
			"https://discord.com/api/webhooks/937358472788475934/YQppuK8SSgYv_v0pRosF3AWBufPiVZui2opq5msMKJ1h-fNhVKsvm3cBRhvHOZ9XqSad",
			["Content-Type:multipart/form-data; boundary=boundary"],
			true,
			HTTPClient.METHOD_POST,
			payload
		)
		Singleton.get_node("SFX/Confirm").play()
		reset_data()


func assemble_package() -> String:
	var package = ""
	package += add_data("platform", OS.get_name())
	package += add_data("version", Singleton.VERSION)
	package += add_data("timestamp", Time.get_ticks_msec())
	package += add_data("window_size", get_window().get_size())
	package += add_data("fullscreen", ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))
	package += add_data("room", get_tree().get_current_scene().get_scene_file_path())
	var player = $"/root/Main/Player"
	if player == null:
		package += add_data("no_player", "")
	else:
		package += add_data("pos", player.position)
		package += add_data("rot", player.rotation)
		package += add_data("zoom", player.get_node("Camera3D").zoom)
	return package
	

func reset_data():
	$Panel/TextEdit.text = ""
	$Panel2/LineEdit.text = ""
	for check in $Checkboxes.get_children():
		check.button_pressed = false
	for mood in $Traffic.get_children():
		mood.button_pressed = false


func _on_Cancel_pressed():
	visible = false
	get_tree().paused = Singleton.pause_menu
	Singleton.set_pause("feedback", false)
