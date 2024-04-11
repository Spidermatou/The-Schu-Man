extends TextureProgressBar

signal isEmpty

@onready var _variation : Label = $Variation
@onready var _icon : Sprite2D = $Icon
@export var iconTexture : Texture2D

func setVariation(value : int):
	if value < 0:
		_variation.text = str(value)
	else:
		_variation.text = "+" + str(value)

func showVariation():
	_variation.show()

func hideVariation():
	_variation.hide()

func _ready():
	showVariation()
	setVariation(0)

func _process(delta):
	_icon.texture = iconTexture

