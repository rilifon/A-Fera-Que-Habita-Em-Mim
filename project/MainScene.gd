extends Node2D

var player_data

func _ready():
	player_data = load("res://player_data.gd").new()
	player_data.init()
	
	for button in $Buttons.get_children():
		button.set_player(player_data)
		button.connect("acted", self, "_on_button_pressed")


func _on_button_pressed(button):
	pass
