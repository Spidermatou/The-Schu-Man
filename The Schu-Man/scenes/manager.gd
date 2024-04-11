extends Node

@export var PATH_TO_JSON : String = "ressources/data.json" 
var lastCards : Array = []
var cardsData 

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

func _ready():
	# Initialisation
	loadData()
	nextCard()
