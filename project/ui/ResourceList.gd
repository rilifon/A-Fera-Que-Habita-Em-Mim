extends Control

const LABEL = preload("res://ui/ResourceLabel.tscn")
const BUTTON = preload("res://ui/ResourceButton.tscn")

var player = null

func setup(player_data):
	player = player_data
	
	var bait_mode = false
	for resource_id in player.resources:
		if resource_id != "bait":
			var resource = player.resources[resource_id]
			if not bait_mode:
				var new_label = LABEL.instance()
				new_label.text = "%s: %d %s" % [resource.name, resource.amount, resource.suffix]
				$VBoxContainer.add_child(new_label)
				if not resource.showing:
					new_label.hide()
			else:
				var new_button = BUTTON.instance()
				new_button.text = "                 %s: %d %s" % [resource.name, resource.amount, resource.suffix]
				new_button.pressed = false
				new_button.type = resource_id
				$VBoxContainer.add_child(new_button)
				if not resource.showing:
					new_button.hide()

		else:
			bait_mode = true
			var new_label = LABEL.instance()
			new_label.text = "--ISCAS--"
			$VBoxContainer.add_child(new_label)

func get_selected_bait():
	for button in $VBoxContainer.get_children():
		if button is Button and button.pressed:
			return button.type
	return null
