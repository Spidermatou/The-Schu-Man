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

var right_arrow_pressed = false
var left_arrow_pressed = false
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_RIGHT and !right_arrow_pressed:
			left_arrow_pressed = false
			right_arrow_pressed = true
			peakToRight.emit()
			print(peakToRight)
		if event.keycode == KEY_LEFT:
			right_arrow_pressed = false
			left_arrow_pressed = true
			peakToLeft.emit()
			print(peakToLeft)
		if event.keycode == KEY_RIGHT and right_arrow_pressed:
			right_arrow_pressed = false
			cardChosen.emit(true)
			print(cardChosen)
		if event.keycode == KEY_LEFT and left_arrow_pressed:
			left_arrow_pressed = false
			cardChosen.emit(false)
			print(cardChosen)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
