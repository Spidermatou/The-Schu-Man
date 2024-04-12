extends Node2D

signal restart

func endGame():
	show()
	get_tree().paused = true

func setExplication(text : String):
	$Explication.text = text

func setImage(image : Texture2D):
	$Image.texture = image

func _on_exit_pressed():
	get_tree().quit()

func _on_button_pressed():
	get_tree().paused = false
	hide()
	restart.emit()
