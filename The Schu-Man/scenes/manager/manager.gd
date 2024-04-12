extends Node

@export var PATH_TO_JSON : String = "res://ressources/cards.json" 
var lastCardsIndexes : Array = []
var cardsData = {}
var actualCardIndex : int = 0
var targetedDepartment : int = 0

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
	$Contextualization.show()
	loadData()
	initGame()
	_endGameScreen.restart.connect(_on_restart)

func initGame():
	resetUI()
	nextCard(false)
	
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

func nextCard(buildingBecomeOlder : bool = true): 
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
		
		# choose the target
		if (card["targetAll"] == 1): targetedDepartment = _campus.buildings.ALL
		else: targetedDepartment = randi_range(0, _campus.buildings.size()-1)
		
	# all buildings become older
	if (buildingBecomeOlder): agingBuildings() # not called for first card

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
	if (card[sideName]["healthVariation"] >= 0): calculSign = "+"
	# retrieve info
	var buildingDisplayedName : String = _campus.get_building_name(targetedDepartment)
	if (card[sideName]["healthVariation"] != 0):
		var renovationInfosText : String = "Niveau d'entretien pour " + buildingDisplayedName + " " + calculSign + str(card[sideName]["healthVariation"])
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
	_financeGauge.addToValue(card[side]["budget"])
	_internGauge.addToValue(card[side]["internalSatisfaction"])
	_centralGauge.addToValue(card[side]["centralSatisfaction"])
	
	# bulding
	var buildingName : String = _campus.get_building_name(targetedDepartment)
	var healthVariation : int = card[side]["healthVariation"]
	if (targetedDepartment == _campus.buildings.ALL): _campus.addToAllHealth(healthVariation)
	else: _campus.addToHealth(targetedDepartment, healthVariation)
	resetUI()
	nextCard()

func _on_campus_ruined_building(building : int):
	var buildingName : String = _campus.get_building_name(building)
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

func agingBuildings():
	_campus.addToAllHealth(-5)


func _on_campus_renovated_building():
	_endGameScreen.endGame()
	# _endGameScreen.texture = load("res://path/to/your/texture.png")
	_endGameScreen.setExplication("Bravo, vous avez réussi votre objectif principale de votre quinquennat, rénover tout les batîments")

