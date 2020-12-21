extends Node2D

var player_data

func _ready():
	$NoBaitSelected.modulate.a = 0.0
	
	player_data = load("res://player_data.gd").new()
	player_data.init()
	
	player_data.connect("update_resources", $ResourceList, "update_resources")
	
	for button in $Buttons.get_children():
		button.setup(player_data, self)
		button.connect("acted", self, "_on_button_pressed")
	
	$ResourceList.setup(player_data)


func get_selected_bait():
	return $ResourceList.get_selected_bait()


func _on_button_pressed(button):
	pass


func _on_Fishing_no_bait_selected():
	AudioManager.play_sfx("error_button")
	if $NoBaitSelected.modulate.a > 0:
		return
	$NoBaitSelected.modulate.a = 1.0
	yield(get_tree().create_timer(1.5), "timeout")
	$NoBaitSelected.modulate.a = 0.0
