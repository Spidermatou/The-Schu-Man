extends Button

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		exitGame()

func _on_pressed():
	exitGame()

func exitGame():
	get_tree().quit(0)
