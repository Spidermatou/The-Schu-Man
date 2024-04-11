extends Node2D

func setExplication(text : String):
	$Explication.text = text

func setImage(image : Texture2D):
	$Image.texture = image

func _on_exit_pressed():
	get_tree().quit()
