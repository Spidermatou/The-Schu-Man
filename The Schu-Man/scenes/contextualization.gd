extends Control

func _ready():
	self.show()

func _on_close_pressed():
	self.hide()
	self.queue_free()
