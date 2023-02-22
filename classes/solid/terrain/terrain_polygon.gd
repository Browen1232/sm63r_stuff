@tool
extends Polygon2D

@export var texture_spritesheet: Texture2D : set = update_spritesheets

var body = ImageTexture.new()
var top = ImageTexture.new()
var top_shade = ImageTexture.new()
var top_corner = ImageTexture.new()
var top_corner_shade = ImageTexture.new()
var edge = ImageTexture.new()
var bottom = ImageTexture.new()

@export var up_direction: Vector2 = Vector2(0, -1) : set = set_down_direction
@export var down_direction: Vector2 = Vector2(0, 1) : set = set_null
@export var max_deviation: int = 60

@export var shallow: bool = false
@export var shallow_color: Color = Color(1, 1, 1, 0.5)

var properties: Dictionary = {}

@onready var decorations = $Decorations


func set_glowing(should_glow):
	shallow = should_glow
	update()
#	visible = !should_glow


func set_down_direction(new_val):
	up_direction = new_val
	down_direction = new_val.tangent().tangent()

func set_null(_new_val):
	pass


func update_spritesheets(new_sheet):
	texture_spritesheet = new_sheet
	
	# Create textures from the spritesheet
	# I wanted to use atlas texture but support for it is bad
	
	body.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(36, 3, 32, 32) ) )
	body.flags = Texture2D.FLAG_REPEAT
	edge.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(3, 3, 32, 32) ) )
	edge.flags = Texture2D.FLAG_REPEAT
	bottom.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(36, 36, 32, 32) ) )
	bottom.flags = Texture2D.FLAG_REPEAT

	top.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(105, 3, 32, 32) ) )
	top.flags = Texture2D.FLAG_REPEAT
	top_corner.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(72, 3, 32, 32) ) )
	top_corner.flags = Texture2D.FLAG_REPEAT
	top_shade.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(105, 36, 32, 32) ) )
	top_shade.flags = Texture2D.FLAG_REPEAT
	top_corner_shade.create_from_image( texture_spritesheet.get_data().get_rect( Rect2(72, 36, 32, 32) ) )
	top_corner_shade.flags = Texture2D.FLAG_REPEAT


func _draw():
	decorations.update()
