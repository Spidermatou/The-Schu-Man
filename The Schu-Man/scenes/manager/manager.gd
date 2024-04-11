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

func nextCard(): 
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
	# renovations
	_renovationEffectLeft.text =""
	_renovationEffectRight.text =""

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
	
	# reset renovation effect
	_renovationEffectLeft.text = ""
	_renovationEffectRight.text = ""

func _on_gauge_finance_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")

func _on_gauge_central_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")

func _on_gauge_intern_is_empty():
	_endGameScreen.show()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")

func peakInfos(isRightSide : bool):
	var sideName : String
	if (isRightSide): 
		sideName = "effectRight"
		# reset the other side		
		_renovationEffectLeft.text = ""
	else:
		sideName = "effectLeft"
		# reset the other side
		_renovationEffectRight.text = ""
	# retrieve potential gauges's variations 
	var card = cardsData[actualCardIndex]
	_financeGauge.setVariation(card[sideName]["budget"])
	_internGauge.setVariation(card[sideName]["internalSatisfaction"])
	_centralGauge.setVariation(card[sideName]["internalSatisfaction"])
	# show them on screen
	_financeGauge.showVariation()
	_internGauge.showVariation()
	_centralGauge.showVariation()
	# apply renovation
	var sign : String = ""
	if ( str(card[sideName]["building"]) != ""):
		# get true building name
		var buildingDisplayedName : String = ""
		match("building"):
			"SSU": buildingDisplayedName = "du service de Sante Universitaire"
			"CENTRAL": buildingDisplayedName = "du batiment central"
			"CHEMISTRY": buildingDisplayedName = "du batiment chimie"
			"CIVILENGINEERING": buildingDisplayedName = "du batiment genie civil"
			"LEO": buildingDisplayedName = "de l'amphi Leo"
			_: buildingDisplayedName = "du batiment informatique"
		# retrieve info
		if (card[sideName]["healthVariation"] >= 0): sign = "+"
		var renovationInfosText : String = "Niveau d'entretien " + buildingDisplayedName + " " + sign + str(card[sideName]["healthVariation"])
		if (isRightSide): 
			_renovationEffectRight.text = renovationInfosText
		else:
			_renovationEffectLeft.text = renovationInfosText

func _on_card_peak_to_left():
	peakInfos(false)

func _on_card_peak_to_right():
	peakInfos(true)

func _on_card_card_chosen(value : bool):
	var card = cardsData[actualCardIndex]
	var side : String 
	if (value == true): side = "effectRight"
	else: side = "effectLeft"
	_financeGauge.value += card[side]["budget"]
	_internGauge.value += card[side]["budget"]
	_centralGauge.value += card[side]["budget"]
	
	# bulding
	var buildingName : String = card[side]["building"]
	var enumValue : int = -1
	if (buildingName != ""):
		# see which building will be affected
		match(buildingName):
			"IT": enumValue = _campus.buildings.IT
			"SSU": enumValue = _campus.buildings.SSU
			"CENTRAL": enumValue = _campus.buildings.CENTRAL
			"CHEMISTRY": enumValue = _campus.buildings.CHEMISTRY
			"CIVILENGINEERING": enumValue = _campus.buildings.CIVILENGINEERING
			"LEO": enumValue = _campus.buildings.LEO
			_: enumValue = _campus.buildings.LEO
		# affected the building
		var renovationValue : int = card[side]["healthVariation"]
		_campus.addToHealth(enumValue, renovationValue)
	resetUI()
	nextCard()
