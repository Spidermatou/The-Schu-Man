extends TextureProgressBar

signal isEmpty

@onready var _variation : Label = $Variation
@onready var _gaugeNameLabel : Label = $Nom
@onready var _icon : Sprite2D = $Icon

@export var iconTexture : Texture2D
@export var gaugeName : String = ""

const COLORS = {"Green":"06ff15", "Red": "e81c1c"}

func setVariation(variation : int):
	if variation < 0:
		_variation.text = str(variation)
		_variation.set("theme_override_colors/font_color", Color(COLORS["Red"]))
	else:
		_variation.text = "+" + str(variation)
		_variation.set("theme_override_colors/font_color", Color(COLORS["Green"]))

func showVariation():
	_variation.show()

func hideVariation():
	_variation.hide()
	
func setValue(number: int):
	self.value += number
	
	if self.value <= 5:
		isEmpty.emit()
		
func setIcone(icone : Texture2D):
	_icon.texture = icone

func _ready():
	showVariation()
	setVariation(0)
	if _gaugeNameLabel.text == "Budget":
		_icon.texture = load("res://ressources/images/gauge_dollars.png")
	if _gaugeNameLabel.text == "Relation avec le Central de l'université":
		_icon.texture = load("res://ressources/images/gauge_central.png")
	if _gaugeNameLabel.text == "Relation avec étudiants et profs":
		_icon.texture = load("res://ressources/images/gauge_etu.jpg")
	_gaugeNameLabel.text = gaugeName



