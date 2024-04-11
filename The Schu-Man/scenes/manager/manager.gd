extends Node

@export var PATH_TO_JSON : String = "ressources/data.json" 
var lastCards : Array = []
var cardsData = {}

# children
@onready var _endGameScreen = $EndGameScreen
@onready var _campus = $Campus
@onready var _financeGauge = $GaugeFinance
@onready var _centralGauge = $GaugeCentral
@onready var _internGauge = $GaugeIntern

func loadData():
	var json = JSON.new()
	var loaded = FileAccess.open(PATH_TO_JSON, FileAccess.READ)
	var text : String = loaded.get_as_text()
	if loaded:
		var error = json.parse(text)
		if error == OK:
			cardsData = json.data
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", loaded, " at line ", json.get_error_line())

func nextCard(): # TODO
	if cardsData.size() > 0:
		# Choisissez une clé aléatoire parmi les clés du dictionnaire
		var keys = cardsData.keys()
		var random_key = keys[randi_range(0, keys.size() - 1)]

		# Récupérer les valeurs associées à cette clé
		var card = cardsData[random_key]
		var dialog = card["dialog"]
		var effectRight = card["effectRight"]
		var effectLeft = card["effectLeft"]
		var financeRight =  card["effectRight"]["finance"]

		# Afficher les valeurs récupérées
		print("Dialog:", dialog)
		print("Effect Right:", effectRight)
		print("Effect Left:", effectLeft)
		print("finance: ", financeRight)

func refuseCard():
	nextCard()
	
func acceptCard():
	# TODO
	# set gauges
	nextCard()

# TODO rename
func handlePeakToLeft():
	pass

# TODO rename
func handlePeakToRight():
	pass

func _ready():
	# reset debug
	$MapBackground.color = Color(255,255,255)
	
	# initialisation
	loadData()
	nextCard()
	
	# default values
	_financeGauge.value = 50
	_internGauge.value = 50
	_centralGauge.value = 50
	_campus.setAllHealth(50)
	
	# hide useless
	_endGameScreen.hide()
	_financeGauge.hideVariation()
	_internGauge.hideVariation()
	_centralGauge.hideVariation()
	
	# according to scenario
	_campus.setHealth(_campus.buildings.CIVILENGINEERING, 100)
	_campus.setHealth(_campus.buildings.LEO, 80)
	
	# test

func _on_gauge_finance_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")

func _on_gauge_central_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")

func _on_gauge_intern_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")
