extends Node

@export var PATH_TO_JSON : String = "ressources/cards.json" 
var lastCardsIndexes : Array = []
var cardsData = {}
var actualCardIndex : int = 0

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
			cardsData = json.data["cards"]
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", loaded, " at line ", json.get_error_line())

func nextCard(): # TODO
	var size : int = cardsData.size() 
	if size > 0:
		var randomInd : int = randi_range(0, size - 1)
		
		# choose a card
		var card = cardsData[randomInd]
		
		# retrieve properties
		var dialogue = card["dialogue"]
		var imagePath = card["image"]
		
		var budgetRight = card["effectRight"]["budget"]
		var centralRight = card["effectRight"]["centralSatisfaction"]
		var internRight = card["effectRight"]["internalSatisfaction"]
		var renovationRight = card["effectRight"]["renovation"]
		var buildingRight = card["effectRight"]["building"]
		
		var budgetLeft = card["effectLeft"]["budget"]
		var centralLeft = card["effectLeft"]["centralSatisfaction"]
		var internLeft = card["effectLeft"]["internalSatisfaction"]
		var renovationLeft = card["effectLeft"]["renovation"]
		var buildingLeft = card["effectLeft"]["building"]
		
		# save 
		actualCardIndex = randomInd

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
