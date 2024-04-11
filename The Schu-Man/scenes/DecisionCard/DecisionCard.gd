extends Node2D

signal peakToRight
signal peakToLeft
signal cardChosen(value : bool)
# Called when the node enters the scene tree for the first time.
func _ready():
	setImage(load("res://icon.svg"))
	setDialog("Je test pour voir le dialogue si tout passe bien parfait j'aime bien Et jen rajoute")

func setImage(newImage : Texture2D):
	var image = get_node("DecisionCardImage")
	if newImage != null:
		image.texture = newImage
	else:
		print("La texture fournie est nulle.")
		
func setDialog(dialog : String):
	var dialogBox = get_node("DialogBox")
	dialogBox.text + dialog

var right_arrow_pressed = 0
var left_arrow_pressed = 0
var pos = get_position()
func _input(event):
	if event is InputEventKey:
		
		if event.pressed:
			if event.keycode == KEY_RIGHT and right_arrow_pressed == 0:
				var newpos = Vector2(pos.x+100, pos.y-40)
				set_position(newpos)
				rotation_degrees = 12.8
				left_arrow_pressed = 0
				right_arrow_pressed += 1
				peakToRight.emit()
				print(peakToRight)
				return
		
			if event.keycode == KEY_LEFT and left_arrow_pressed == 0:
				var newpos = Vector2(pos.x-100, pos.y+30)
				set_position(newpos)
				rotation_degrees = -12.8
				right_arrow_pressed = 0
				left_arrow_pressed += 1
				peakToLeft.emit()
				print(peakToLeft)
				return
		
			if event.keycode == KEY_RIGHT and right_arrow_pressed == 1:
				set_position(pos)
				rotation_degrees = 0
				right_arrow_pressed = 0
				cardChosen.emit(true)
				print(cardChosen)
				return
		
			if event.keycode == KEY_LEFT and left_arrow_pressed == 1:
				set_position(pos)
				rotation_degrees = 0
				left_arrow_pressed = 0
				cardChosen.emit(false)
				print(cardChosen)
				return

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
