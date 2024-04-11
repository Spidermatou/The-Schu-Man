extends TextureProgressBar

signal isEmpty

@onready var _variation : Label = $Variation
@onready var _icon : Sprite2D = $Icon
@onready var _gaugeNameLabel : Label = $Nom

@export var iconTexture : Texture2D
@export var gaugeName : String = ""

var signalEmitted : bool = false;

func setVariation(variation : int):
	if variation < 0:
		_variation.text = str(variation)
	else:
		_variation.text = "+" + str(variation)

func showVariation():
	_variation.show()

func hideVariation():
	_variation.hide()

func _ready():
	showVariation()
	setVariation(0)

func setIcone(icone : Texture2D):
	_icon.texture = icone

func _process(delta):
	if _gaugeNameLabel.text == "Budget":
		_icon.texture = load("res://ressources/images/gauge_dollars.png")
	if _gaugeNameLabel.text == "Relation avec le Central de l'université":
		_icon.texture = load("res://ressources/images/gauge_central.png")
	if _gaugeNameLabel.text == "Relation avec étudiants et profs":
		_icon.texture = load("res://ressources/images/gauge_etu.jpg")
	_gaugeNameLabel.text = gaugeName
	
	if (self.value <= 5 && !signalEmitted):
		isEmpty.emit()
		signalEmitted = true
