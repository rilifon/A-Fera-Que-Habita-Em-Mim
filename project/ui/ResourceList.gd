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
				new_label.type = resource_id
				set_resource_text(new_label)
				$VBoxContainer.add_child(new_label)
				if not resource.showing:
					new_label.hide()
			else:
				var new_button = BUTTON.instance()
				new_button.type = resource_id
				set_resource_text(new_button)
				new_button.pressed = false
				$VBoxContainer.add_child(new_button)
				if not resource.showing:
					new_button.hide()

		else:
			bait_mode = true
			var new_label = LABEL.instance()
			new_label.text = "--ISCAS--"
			new_label.type = false
			$VBoxContainer.add_child(new_label)

func get_selected_bait():
	for button in $VBoxContainer.get_children():
		if button is Button and button.pressed:
			return button.type
	return null

func update_resources():
	for resource in $VBoxContainer.get_children():
		if resource.type:
			set_resource_text(resource)


func set_resource_text(resource_object):
	var resource = player.resources[resource_object.type]
	if resource_object is Button:
		resource_object.text = "                 %s: %d %s" % [resource.name, resource.amount, resource.suffix]
	elif resource_object is Label:
		resource_object.text = "%s: %d %s" % [resource.name, resource.amount, resource.suffix]
