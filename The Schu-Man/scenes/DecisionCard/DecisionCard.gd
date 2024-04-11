extends Node2D

signal peakToRight
signal peakToLeft
signal cardChosen(value : bool)

@onready var card : Node2D = $Card
@onready var cardIllustration : Sprite2D = $Card/Image

var right_arrow_pressed : bool = false
var left_arrow_pressed : bool = false

func setImage(newImage : Texture2D):
	var image = $Card/Image
	if newImage != null:
		image.texture = newImage

func setDialog(dialog : String):
	$Card/DialogBox.text = dialog

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			
			if Input.is_action_pressed("ui_right") and !right_arrow_pressed:
				card.position = Vector2(100, 40)
				card.rotation_degrees = 12.5
				
				left_arrow_pressed = false
				right_arrow_pressed = true
				
				peakToRight.emit()
				return
		
			if Input.is_action_pressed("ui_left") and !left_arrow_pressed:
				card.position = Vector2(-100, 40)
				card.rotation_degrees = -12.5
				
				right_arrow_pressed = false
				left_arrow_pressed = true
				
				peakToLeft.emit()
				return
		
			if Input.is_action_pressed("ui_right") and right_arrow_pressed:
				card.position = Vector2(0,0)
				card.rotation_degrees = 0
				
				right_arrow_pressed = false
				cardChosen.emit(true)
				return
		
			if Input.is_action_pressed("ui_left") and left_arrow_pressed:
				card.position = Vector2(0,0)
				card.rotation_degrees = 0
				
				left_arrow_pressed = false
				
				cardChosen.emit(false)
				return

func _process(delta):
	cardIllustration.scale = Vector2(190, 190) / cardIllustration.texture.get_size()
