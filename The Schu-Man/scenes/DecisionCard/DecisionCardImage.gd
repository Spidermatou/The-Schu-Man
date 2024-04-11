extends Sprite2D

var maxSize = Vector2(238, 238)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func set_max_size():
	var texture_size = texture.get_size()
	var scale = Vector2(1, 1)
	if texture_size.x > maxSize.x:
		scale.x = maxSize.x / texture_size.x
	if texture_size.y > maxSize.y:
		scale.y = maxSize.y / texture_size.y
	if texture_size.x < maxSize.x:
		scale.x = maxSize.x / texture_size.x
	if texture_size.y / maxSize.y:
		scale.y = maxSize.y / texture_size.y
	set_scale(scale)
	set_position(Vector2(17+texture_size.x, 20+texture_size.y))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_max_size()
