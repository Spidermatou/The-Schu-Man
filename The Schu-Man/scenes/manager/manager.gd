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
@onready var _buildingEffectLeft = $BuildingEffectLeft
@onready var _buildingEffectRight = $BuildingEffectRight
@onready var _tuto = $Tuto

func _ready():
	# initialisation
	loadData()
	initGame()
	
	_endGameScreen.restart.connect(_on_restart)
	
func initGame():
	resetUI()
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
	_buildingEffectLeft.text = ""
	_buildingEffectRight.text = ""

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
	_buildingEffectLeft.text =""
	_buildingEffectRight.text =""
	# tuto
	_tuto.toAffichage()

func peakInfos(isRightSide : bool):
	var sideName : String
	if (isRightSide): 
		sideName = "effectRight"
		# reset the other side		
		_buildingEffectLeft.text = ""
	else:
		sideName = "effectLeft"
		# reset the other side
		_buildingEffectRight.text = ""
	# retrieve potential gauges's variations 
	var card = cardsData[actualCardIndex]
	_financeGauge.setVariation(card[sideName]["budget"])
	_internGauge.setVariation(card[sideName]["internalSatisfaction"])
	_centralGauge.setVariation(card[sideName]["centralSatisfaction"])
	# show them on screen
	_financeGauge.showVariation()
	_internGauge.showVariation()
	_centralGauge.showVariation()
	# apply renovation
	var calculSign : String = ""
	if ( str(card[sideName]["building"]) != ""):
		# get true building name
		var buildingDisplayedName : String = ""
		match("building"):
			"SSU": buildingDisplayedName = "du Service de Sante Universitaire"
			"CENTRAL": buildingDisplayedName = "du batiment central"
			"CHEMISTRY": buildingDisplayedName = "du batiment chimie"
			"CIVILENGINEERING": buildingDisplayedName = "du batiment genie civil"
			"LEO": buildingDisplayedName = "de l'amphi Leo"
			_: buildingDisplayedName = "du batiment informatique"
		# retrieve info
		if (card[sideName]["healthVariation"] >= 0): calculSign = "+"
		if (card[sideName]["healthVariation"] != 0):
			var renovationInfosText : String = "Niveau d'entretien " + buildingDisplayedName + " " + calculSign + str(card[sideName]["healthVariation"])
			if (isRightSide): 
				_buildingEffectRight.text = renovationInfosText
			else:
				_buildingEffectLeft.text = renovationInfosText
	_tuto.toConfirm()

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
	_internGauge.value += card[side]["internalSatisfaction"]
	_centralGauge.value += card[side]["centralSatisfaction"]
	
	# bulding
	var buildingName : String = card[side]["building"]
	if (buildingName != ""):
		var healthVariation : int = card[side]["healthVariation"]
		# see which building will be affected
		match(buildingName):
			"IT": _campus.addToHealth(_campus.buildings.IT, healthVariation)
			"SSU": _campus.addToHealth(_campus.buildings.SSU, healthVariation)
			"CENTRAL": _campus.addToHealth(_campus.buildings.CENTRAL, healthVariation)
			"CHEMISTRY": _campus.addToHealth(_campus.buildings.CHEMISTRY, healthVariation)
			"CIVILENGINEERING": _campus.addToHealth(_campus.buildings.CIVILENGINEERING, healthVariation)
			"LEO": _campus.addToHealth(_campus.buildings.LEO, healthVariation)
			_: _campus.addToAllHealth(healthVariation)
		
	resetUI()
	nextCard()

func _on_campus_ruined_building(building : int):
	var buildingName : String = ""
	match(building):
		_campus.buildings.IT : buildingName = "le batiment informatique"
		_campus.buildings.SSU : buildingName = "le batiment du Service de Sante Universitaire"
		_campus.buildings.CENTRAL : buildingName = "le batiment central"
		_campus.buildings.CHEMISTRY : buildingName = "le batiment chimie"
		_campus.buildings.CIVILENGINEERING : buildingName = "le batiment genie civil"
		_ : buildingName = "l'amphi Leo"
		
	_endGameScreen.endGame()
	_endGameScreen.setExplication("Oh non ! Apparement, " + buildingName + " vient de s'effondrer. L'universite a decide de vous virer pour negligence...")

func _on_gauge_finance_is_empty():
	_endGameScreen.endGame()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")
	_endGameScreen.setExplication("Oh non ! Le campus est en faillite, les profs sont partis après que leur salaire n'a pas été payé à temps, et les élèves ont finis par suivre... Vous dirigez un campus fantôme.")

func _on_gauge_central_is_empty():
	_endGameScreen.endGame()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")
	_endGameScreen.setExplication("Oh non ! Le central de l'universite vous déteste. Dès la fin de votre quinquennat, plus personne n'a voté pour vous. Vous êtes au chômage...")

func _on_gauge_intern_is_empty():
	_endGameScreen.endGame()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")
	_endGameScreen.setExplication("Oh non ! Les équipes vous déteste, plus personne ne suit vos demandes ni ne veut travailler avec vous. Vous n'avez plus de directeur que le nom...")

func _on_restart():
	initGame()
