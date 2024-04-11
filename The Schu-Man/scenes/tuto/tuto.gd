extends Control

@onready var _text = $MainText

func _ready():
	toAffichage()

func toAffichage():
	_text.text = "afficher des infos"

func toConfirm():
	_text.text = "confirmer"
