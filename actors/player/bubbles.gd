extends Sprite

onready var viewport = $"../BubbleViewport"
onready var cam = $"../Camera2D"

func refresh():
	#set the viewport size to the window size
	viewport.size = OS.window_size
	#create a texture for the bubbles
	var tex = ImageTexture.new()
	tex.create(viewport.size.x, viewport.size.y, Image.FORMAT_RGB8)
	texture = tex
	#now give the shader our viewport texture
	material.set_shader_param("viewport_texture", viewport.get_texture())

func _ready():
	refresh()
	#deparent this node
	$"/root/Main/Player".call_deferred("remove_child", self)
	$"/root/Main".call_deferred("add_child", self)
	#deparent the viewport
	$"/root/Main/Player".call_deferred("remove_child", viewport)
	$"/root/Main".call_deferred("add_child", viewport)

func _process(_delta):
	viewport.canvas_transform = get_canvas_transform()
	#set the position to the screen center
	scale = Vector2(1, 1) / cam.get_canvas_transform().get_scale()
	position = (viewport.size / 2 - cam.get_canvas_transform().origin) * scale
