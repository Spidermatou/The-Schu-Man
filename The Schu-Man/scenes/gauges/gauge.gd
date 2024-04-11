extends TextureProgressBar

signal isEmpty

@onready var _variation : Label = $Variation
@onready var _icon : Sprite2D = $Icon
@onready var _gaugeNameLabel : Label = $Nom

@export var iconTexture : Texture2D
@export var gaugeName : String = ""

const COLORS = {"Green":"06ff15", "Red": "e81c1c"}

var signalEmitted : bool = false;

func setVariation(value : int):
	if value < 0:
		_variation.text = str(value)
		_variation.set("theme_override_colors/font_color", Color(COLORS["Red"]))
	else:
		_variation.text = "+" + str(value)
		_variation.set("theme_override_colors/font_color", Color(COLORS["Green"]))

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
		emit_signal("isEmpty")
		signalEmitted = true
		print("emit empty")
		
