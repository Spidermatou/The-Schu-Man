extends Control

func _ready():
	self.show()
	get_tree().paused = true

func _on_close_pressed():
	self.hide()
	self.queue_free()
	get_tree().paused = false
