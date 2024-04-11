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
@onready var _card = $Card
@onready var _renovationEffectLeft = $RenovationEffectLeft
@onready var _renovationEffectRight = $RenovationEffectRight

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
	# choose new card dataset	
	var size : int = cardsData.size() 
	var randomInd : int = -1
	if size > 0:
		while (lastCardsIndexes.has(randomInd)):
			randomInd = randi_range(0, size - 1)
		
		# choose a card
		var card = cardsData[randomInd]
		
		# set card
		_card.setDialog(card["dialogue"])
		_card.setImage(load(card["image"]))

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
		lastCardsIndexes.append(randomInd)
		if (lastCardsIndexes.size() >= 5): lastCardsIndexes.remove_at(0)

func resetUI():
	# reset gauges indications
	_financeGauge.hideVariation()
	_internGauge.hideVariation()
	_centralGauge.hideVariation()
	# reset card
	_card.setDialog("")
	_card.setImage(null)

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


func _on_card_peak_to_left():
	var card = cardsData[actualCardIndex]
	_financeGauge.setVariation(card["effectLeft"]["budget"])
	_internGauge.setVariation(card["effectLeft"]["internalSatisfaction"])
	_centralGauge.setVariation(card["effectLeft"]["internalSatisfaction"])
	
	# show them
	_financeGauge.showVariation()
	_internGauge.showVariation()
	_centralGauge.showVariation()
	
	# renovation
	if ( str(card["effectLeft"]["building"]) != ""):
		_renovationEffectRight.text = str(card["effectLeft"]["building"]) + " : " + str(card["effectLeft"]["renovation"])


func _on_card_peak_to_right():
	var card = cardsData[actualCardIndex]
	_financeGauge.setVariation(card["effectRight"]["budget"])
	_internGauge.setVariation(card["effectRight"]["internalSatisfaction"])
	_centralGauge.setVariation(card["effectRight"]["internalSatisfaction"])

	# show them
	_financeGauge.showVariation()
	_internGauge.showVariation()
	_centralGauge.showVariation()
	
	# renovation
	if ( str(card["effectRight"]["building"]) != ""):
		_renovationEffectRight.text = str(card["effectRight"]["building"]) + " : " + str(card["effectRight"]["renovation"])

func _on_card_card_chosen(value : bool):
	var card = cardsData[actualCardIndex]
	var side : String 
	if (value == true): side = "effectRight"
	else: side = "effectLeft"
	_financeGauge.value += card[side]["budget"]
	_internGauge.value += card[side]["budget"]
	_centralGauge.value += card[side]["budget"]
	resetUI()
	nextCard()
